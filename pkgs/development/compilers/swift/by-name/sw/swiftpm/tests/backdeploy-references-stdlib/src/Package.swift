// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "backdeploy-references-stdlib",
    platforms: [.macOS("11.0")],
    products: [
        .executable(name: "backdeploy-references-stdlib", targets: ["backdeploy-references-stdlib"])
    ],
    targets: [
        .executableTarget(name: "backdeploy-references-stdlib", path: "Sources")
    ]
)
