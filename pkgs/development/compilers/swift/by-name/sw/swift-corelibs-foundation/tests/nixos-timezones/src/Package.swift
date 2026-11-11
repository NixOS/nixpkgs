// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "nixos-timezones",
    products: [
        .executable(name: "nixos-timezones", targets: ["nixos-timezones"])
    ],
    targets: [
        .executableTarget(name: "nixos-timezones")
    ]
)
