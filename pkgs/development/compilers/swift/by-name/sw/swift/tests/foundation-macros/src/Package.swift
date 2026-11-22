// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "foundation-macros",
    platforms: [.macOS("14.0")],
    products: [
        .executable(name: "foundation-macros", targets: ["foundation-macros"])
    ],
    targets: [
        .executableTarget(name: "foundation-macros", path: "Sources")
    ]
)
