// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "test-swift-testing",
    products: [
        .library(name: "test-swift-testing", type: .dynamic, targets: ["test-swift-testing"])
    ],
    targets: [
        .target(name: "test-swift-testing", path: "Sources"),
        .testTarget(
            name: "test-swift-testing-tests",
            dependencies: ["test-swift-testing"],
            path: "Tests"
        ),
    ]
)
