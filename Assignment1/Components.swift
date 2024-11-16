//
//  Components.swift
//  Assignment1
//
//  Created by Tanveer Ansari on 2024-11-12.
//

import SwiftUI

// Define the ViewModel
class ComponentViewModel: ObservableObject {
    @Published var components: [ComponentSection] = [
            ComponentSection(title: "Text Input/Output", items: [
                ComponentItem(name: "Text", icon: "textformat", documentationURL: "https://developer.apple.com/documentation/swiftui/text"),
                ComponentItem(name: "Label", icon: "tag", documentationURL: "https://developer.apple.com/documentation/swiftui/label"),
                ComponentItem(name: "TextField", icon: "textbox", documentationURL: "https://developer.apple.com/documentation/swiftui/textfield"),
                ComponentItem(name: "SecureField", icon: "lock.shield", documentationURL: "https://developer.apple.com/documentation/swiftui/securefield"),
                ComponentItem(name: "TextArea", icon: "text.alignleft", documentationURL: "https://developer.apple.com/documentation/swiftui/texteditor"),
                ComponentItem(name: "Image", icon: "photo", documentationURL: "https://developer.apple.com/documentation/swiftui/image")
            ]),
            ComponentSection(title: "Controls", items: [
                ComponentItem(name: "Button", icon: "cursorarrow.click", documentationURL: "https://developer.apple.com/documentation/swiftui/button"),
                ComponentItem(name: "Menu", icon: "list.bullet", documentationURL: "https://developer.apple.com/documentation/swiftui/menu"),
                ComponentItem(name: "Link", icon: "link", documentationURL: "https://developer.apple.com/documentation/swiftui/link"),
                ComponentItem(name: "Slider", icon: "slider.horizontal.3", documentationURL: "https://developer.apple.com/documentation/swiftui/slider"),
                ComponentItem(name: "Stepper", icon: "plusminus", documentationURL: "https://developer.apple.com/documentation/swiftui/stepper"),
                ComponentItem(name: "Toggle", icon: "switch.2", documentationURL: "https://developer.apple.com/documentation/swiftui/toggle"),
                ComponentItem(name: "Picker", icon: "dial", documentationURL: "https://developer.apple.com/documentation/swiftui/picker"),
                ComponentItem(name: "DatePicker", icon: "calendar", documentationURL: "https://developer.apple.com/documentation/swiftui/datepicker"),
                ComponentItem(name: "ColorPicker", icon: "paintpalette", documentationURL: "https://developer.apple.com/documentation/swiftui/colorpicker"),
                ComponentItem(name: "ProgressView", icon: "timer", documentationURL: "https://developer.apple.com/documentation/swiftui/progressview")
            ]),
            ComponentSection(title: "Container Views", items: [
                ComponentItem(name: "HStack", icon: "rectangle.split.3x1", documentationURL: "https://developer.apple.com/documentation/swiftui/hstack"),
                ComponentItem(name: "VStack", icon: "rectangle.split.3x1.fill", documentationURL: "https://developer.apple.com/documentation/swiftui/vstack"),
                ComponentItem(name: "ZStack", icon: "square.on.square", documentationURL: "https://developer.apple.com/documentation/swiftui/zstack"),
                ComponentItem(name: "Form", icon: "square.text.square", documentationURL: "https://developer.apple.com/documentation/swiftui/form"),
                ComponentItem(name: "NavigationView", icon: "rectangle.3.offgrid", documentationURL: "https://developer.apple.com/documentation/swiftui/navigationview"),
                ComponentItem(name: "Alerts", icon: "exclamationmark.triangle", documentationURL: "https://developer.apple.com/documentation/swiftui/alert"),
                ComponentItem(name: "Sheets", icon: "doc.plaintext", documentationURL: "https://developer.apple.com/documentation/swiftui/sheet")
            ]),
            ComponentSection(title: "List Types", items: [
                ComponentItem(name: "Plain List", icon: "list.bullet.rectangle", documentationURL: "https://developer.apple.com/documentation/swiftui/list"),
                ComponentItem(name: "Inset List", icon: "list.bullet.indent", documentationURL: "https://developer.apple.com/documentation/swiftui/liststyle/insetgroupedliststyle"),
                ComponentItem(name: "Grouped List", icon: "rectangle.grid.1x2", documentationURL: "https://developer.apple.com/documentation/swiftui/liststyle/groupedliststyle"),
                ComponentItem(name: "Inset Grouped List", icon: "rectangle.grid.1x2.fill", documentationURL: "https://developer.apple.com/documentation/swiftui/liststyle/insetgroupedliststyle"),
                ComponentItem(name: "Sidebar List", icon: "sidebar.leading", documentationURL: "https://developer.apple.com/documentation/swiftui/liststyle/sidebarliststyle")
            ])
        ]
    @Published var searchText = "" // Search text state
    // Computed property to filter components based on search text
    var filteredComponents: [ComponentSection] {
        if searchText.isEmpty {
            return components
        } else {
            return components.map { section -> ComponentSection in
                let filteredItems = section.items.filter {
                    $0.name.localizedCaseInsensitiveContains(searchText)
                }
                return ComponentSection(title: section.title, items: filteredItems)
            }.filter { !$0.items.isEmpty }
        }
    }

}

struct ComponentSection {
    let title: String
    let items: [ComponentItem]
}

struct ComponentItem {
    let name: String
    let icon: String
    let documentationURL: String
}

struct ContentView: View {
    @StateObject private var viewModel = ComponentViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredComponents, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.items, id: \.name) { item in
                            NavigationLink(destination: DetailView(item: item)) {
                                HStack {
                                    Image(systemName: item.icon)
                                        .foregroundColor(.blue)
                                    Text(item.name)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Components")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(GroupedListStyle())
        }
    }
}




struct DetailView: View {
    var item: ComponentItem
    @State private var textInput: String = ""
    @State private var secureInput: String = ""
    @State private var textAreaInput: String = "Editable text here..."
    @State private var sliderValue: Double = 50
    @State private var stepperValue: Int = 1
    @State private var toggleIsOn: Bool = true
    @State private var selectedPickerIndex: Int = 1
    @State private var selectedDate: Date = Date()
    @State private var selectedColor: Color = .blue

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(item.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.blue)
                Divider()
                componentDemoView(item)
            }
            .padding()
        }
        .navigationTitle(item.name)
        .background(Color(UIColor.systemGroupedBackground)) // Ensures good contrast on both light and dark modes
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Future action for opening documentation
                }) {
                    Image(systemName: "book.fill")
                }
            }
        }
    }

    @ViewBuilder
    func componentDemoView(_ item: ComponentItem) -> some View {
        switch item.name {
        case "Text":
            Text("Hello, world!")
                .font(.title)
                .foregroundColor(Color.green)
        case "Label":
            Label("Welcome", systemImage: "star.fill")
                .foregroundColor(Color.orange)
        case "TextField":
            TextField("Enter text here", text: $textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(5)
        case "SecureField":
            SecureField("Password", text: $secureInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.red.opacity(0.3))
                .cornerRadius(5)
        case "TextArea":
            TextEditor(text: $textAreaInput)
                .frame(height: 100)
                .border(Color.blue, width: 2)
                .cornerRadius(5)
        case "Image":
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
                .background(Color.purple.opacity(0.3))
                .cornerRadius(8)
        case "Button":
            Button("Click me", action: { print("Button tapped") })
                .buttonStyle(FilledRoundedButtonStyle())
        case "Menu":
            Menu("Options") {
                Button("Choice 1", action: { print("Choice 1 selected") })
                Button("Choice 2", action: { print("Choice 2 selected") })
            }
        case "Link":
            Link("Visit Apple", destination: URL(string: "https://apple.com")!)
        case "Slider":
            Slider(value: $sliderValue, in: 0...100)
                .accentColor(.pink)
        case "Stepper":
            Stepper("Quantity: \(stepperValue)", value: $stepperValue)
                .padding()
                .background(Color.cyan.opacity(0.3))
                .cornerRadius(5)
        case "Toggle":
            Toggle("Enable feature", isOn: $toggleIsOn)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
        case "Picker":
            Picker("Select option", selection: $selectedPickerIndex) {
                Text("Option 1").tag(1)
                Text("Option 2").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.orange.opacity(0.3))
        case "DatePicker":
            DatePicker("Select date", selection: $selectedDate)
                .labelsHidden()
                .datePickerStyle(GraphicalDatePickerStyle())
        case "ColorPicker":
            ColorPicker("Pick color", selection: $selectedColor)
                .padding()
        case "ProgressView":
            ProgressView("Downloading...", value: sliderValue, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
        default:
            Text("Component not found")
        }
    }
}

// Custom button style for demonstration
struct FilledRoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.mint)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut, value: configuration.isPressed)
    }
}

@main
struct SwiftUIComponentsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
