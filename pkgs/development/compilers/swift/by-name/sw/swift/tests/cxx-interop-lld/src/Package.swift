// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Repro",
  targets: [
    .executableTarget(
      name: "Repro",
      swiftSettings: [.interoperabilityMode(.Cxx)]
    )
  ]
)
