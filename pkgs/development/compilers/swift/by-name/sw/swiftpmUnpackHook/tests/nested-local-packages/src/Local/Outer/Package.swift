// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Outer",
    products: [.library(name: "Outer", targets: ["Outer"])],
    dependencies: [.package(path: "../Inner")],
    targets: [
        .target(
            name: "Outer",
            dependencies: [.product(name: "Inner", package: "Inner")],
            path: "Sources"
        )
    ]
)
