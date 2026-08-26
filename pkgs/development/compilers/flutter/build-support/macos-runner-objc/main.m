// Fallback runner for Flutter macOS applications whose project has no Swift
// sources in macos/Runner (i.e. non-template projects). Mirrors the behaviour
// of macos-runner-main.swift: programmatic application menu + main window
// hosting a FlutterViewController.
#import <Cocoa/Cocoa.h>
#import <FlutterMacOS/FlutterMacOS.h>

@interface NixRunnerAppDelegate : NSObject <NSApplicationDelegate>
// Strong reference to the view controller (contentViewController is weak).
@property(nonatomic, strong) FlutterViewController *controller;
@end

@implementation NixRunnerAppDelegate
@end

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    NSApplication *app = [NSApplication sharedApplication];

    NixRunnerAppDelegate *delegate = [[NixRunnerAppDelegate alloc] init];
    app.delegate = delegate;
    delegate.controller = [[FlutterViewController alloc] init];

    // Application menu (equivalent to MainMenu.xib).
    NSMenu *mainMenu = [[NSMenu alloc] init];
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
    [mainMenu addItem:appMenuItem];
    NSMenu *appMenu = [[NSMenu alloc] init];
    NSString *appName = NSProcessInfo.processInfo.processName;
    [appMenu addItem:[[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Quit %@", appName]
                                                action:@selector(terminate:)
                                         keyEquivalent:@"q"]];
    appMenuItem.submenu = appMenu;
    app.mainMenu = mainMenu;

    // Main window (equivalent to the MainFlutterWindow in MainMenu.xib).
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 1280, 720)
                                                   styleMask:(NSWindowStyleMaskTitled |
                                                              NSWindowStyleMaskClosable |
                                                              NSWindowStyleMaskMiniaturizable |
                                                              NSWindowStyleMaskResizable)
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    window.contentViewController = delegate.controller;
    window.title = appName;
    [window makeKeyAndOrderFront:nil];

    [app run];
  }
  return 0;
}
