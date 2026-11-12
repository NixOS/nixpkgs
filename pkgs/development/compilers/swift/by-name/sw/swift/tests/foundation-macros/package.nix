{
  stdenv,
  swift,
  swiftpm,
}:

# The primary goal of this test is to confirm that the foundation macros built with the toolchain work on Darwin.
stdenv.mkDerivation {
  name = "swift-test-foundation-macros";

  src = ./src;

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    swift run -c release foundation-macros | grep 'Hello, foundation macros'
    touch "$out"
  '';

  __structuredAttrs = true;
}
