// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftTestingSmokeTest",
    platforms: [.macOS("@darwinMinVersion@")],
    targets: [.testTarget(name: "SmokeTests", path: "Tests")]
)
