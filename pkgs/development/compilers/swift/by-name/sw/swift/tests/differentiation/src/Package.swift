// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "differentiation",
    products: [
        .executable(name: "differentiation", targets: ["differentiation"])
    ],
    targets: [
        .executableTarget(name: "differentiation", path: "Sources")
    ]
)
