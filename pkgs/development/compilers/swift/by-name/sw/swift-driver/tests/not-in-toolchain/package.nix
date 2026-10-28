{
  runCommand,
  swift,
  swiftpm,
  swift_release,
}:

runCommand "swift-driver-test-not-in-toolchain"
  {
    nativeBuildInputs = [
      swift
      swiftpm
    ];
  }
  ''
    swift package --version | grep "Swift Package Manager - Swift ${swift_release}"
    touch "$out"
  ''
