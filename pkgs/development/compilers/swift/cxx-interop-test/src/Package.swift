// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "CxxInteropTest",
    targets: [
        .executableTarget(
            name: "CxxInteropTest",
            path: "Sources",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        )
    ]
)
