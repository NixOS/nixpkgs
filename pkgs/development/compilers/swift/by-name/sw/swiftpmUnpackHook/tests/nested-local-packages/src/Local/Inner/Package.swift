// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Inner",
    products: [.library(name: "Inner", targets: ["Inner"])],
    dependencies: [.package(url: "https://github.com/mrackwitz/Version.git", exact: "0.8.0")],
    targets: [
        .target(
            name: "Inner",
            dependencies: [.product(name: "Version", package: "Version")],
            path: "Sources"
        )
    ]
)
