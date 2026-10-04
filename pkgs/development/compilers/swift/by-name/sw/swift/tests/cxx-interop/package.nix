{
  stdenv,
  swift,
  swiftpm,
}:

stdenv.mkDerivation {
  name = "swift-test-cxx-interop";

  src = ./src;

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildPhase = ''
    swiftpmBuildPhase
    make
  '';

  installPhase = ''
    runHook preInstall
    swift run -c release CxxInteropTest | grep 'Hello, Swift!'
    ./SwiftToCxxInteropTest | grep 'Hello, C++!'
    touch "$out"
    runHook postInstall
  '';

  __structuredAttrs = true;
}
