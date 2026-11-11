{
  stdenv,
  swift,
  swiftpm,
}:

# Test that Swift Differentiation works. This test is particularly important for Darwin because the
# Swift Differentiation dylib is no longer distributed with macOS (as of 26.4).
stdenv.mkDerivation {
  name = "swift-test-differentiation";

  src = ./src;

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    swift run -c release differentiation 4 | grep '8.0'
    touch "$out"
  '';

  __structuredAttrs = true;
}
