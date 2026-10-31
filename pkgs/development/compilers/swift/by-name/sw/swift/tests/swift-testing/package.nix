{
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
}
