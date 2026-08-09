{
  lib,
  swift,
  swiftpm,
  stdenv,
}:

stdenv.mkDerivation {
  name = "swift-test-swift-testing";

  src = ./src;

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  doCheck = true;

  installPhase = ''
    touch "$out"
  '';

  __structuredAttrs = true;

  meta.badPlatforms = [
    # This test won’t work on Darwin until XCTest is modified to work on Darwin without requiring Xcode.
    lib.systems.inspect.patterns.isDarwin
  ];
}
