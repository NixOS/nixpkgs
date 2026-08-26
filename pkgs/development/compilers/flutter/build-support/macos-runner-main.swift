// Nixpkgs buildFlutterApplication — programmatic equivalent of MainMenu.xib
// for environments without a nib compiler.
//
// Template projects build their application shell from MainMenu.xib plus
// MainFlutterWindow's awakeFromNib. Without Xcode (no ibtool/nib compiler)
// this file reproduces that behaviour in code:
//   1. Application main menu (equivalent of the MainMenu.xib menu bar).
//   2. Main window: prefer triggering the project's MainFlutterWindow
//      initialisation (which creates the FlutterViewController and registers
//      plugins); fall back to a standard window hosting a FlutterViewController.
//
// The @main attribute in the template AppDelegate.swift is stripped by the
// build script, leaving this file as the single entry point.
// Note: FlutterAppDelegate implements most NSApplicationDelegate lifecycle
// methods (to forward plugin events), so this file does not go through the
// delegate hooks; it builds the application shell directly.

import Cocoa
import FlutterMacOS

// NSApp.delegate is a weak reference; keep a strong reference to it
// (equivalent of NSApplicationMain behind @main).
private var strongDelegate: NSObject?

let app = NSApplication.shared

if let delegateClass = NSClassFromString("Runner.AppDelegate") as? NSObject.Type {
  strongDelegate = delegateClass.init()
  app.delegate = strongDelegate as? NSApplicationDelegate
}

let appName = ProcessInfo.processInfo.processName

// 1. Main menu (equivalent of MainMenu.xib)
let mainMenu = NSMenu()
let appMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
mainMenu.addItem(appMenuItem)
let appMenu = NSMenu()
appMenu.addItem(
  NSMenuItem(
    title: "Quit \(appName)",
    action: #selector(NSApplication.terminate(_:)),
    keyEquivalent: "q"))
appMenuItem.submenu = appMenu
app.mainMenu = mainMenu

// 2. Main window (equivalent of the MainFlutterWindow in the xib)
let contentRect = NSRect(x: 0, y: 0, width: 1280, height: 720)
if let windowClass = NSClassFromString("Runner.MainFlutterWindow") as? NSWindow.Type {
  let window = windowClass.init(
    contentRect: contentRect,
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false)
  // Trigger the template window initialisation (creates the
  // FlutterViewController and registers plugins).
  // Equivalent of the awakeFromNib message sent on nib loading.
  window.awakeFromNib()
  window.title = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? appName
  window.makeKeyAndOrderFront(nil)
} else {
  let controller = FlutterViewController()
  // Register the nixpkgs built-in macOS plugins (see the generated
  // GeneratedPluginRegistrant.swift) for projects without their own
  // MainFlutterWindow subclass.
  RegisterGeneratedPlugins(registry: controller)
  let window = NSWindow(
    contentRect: contentRect,
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false)
  window.title = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? appName
  window.contentViewController = controller
  window.makeKeyAndOrderFront(nil)
}

app.run()
