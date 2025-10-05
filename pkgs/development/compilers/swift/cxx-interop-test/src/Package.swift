// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "CxxInteropTest",
    targets: [
        .executableTarget(
            name: "CxxInteropTest",
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-enable-experimental-cxx-interop"])
            ]
        )
    ]
)
