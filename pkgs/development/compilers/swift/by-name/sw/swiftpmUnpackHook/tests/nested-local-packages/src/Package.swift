// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Nested",
    dependencies: [.package(path: "Local/Outer")],
    targets: [
        .executableTarget(
            name: "nested",
            dependencies: [.product(name: "Outer", package: "Outer")],
            path: "Sources"
        )
    ]
)
