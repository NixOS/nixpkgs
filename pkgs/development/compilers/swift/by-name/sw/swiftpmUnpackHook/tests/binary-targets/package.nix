{
  lib,
  stdenv,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "test-swiftpm-binary-targets";
  src = ./src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) src;
    name = finalAttrs.name;
    hash = "sha256-ZODLY/KSUt0WvIFR3whpezV+Z5BtBM4mehPTlZDCKMg=";
  };

  # Capacitor can't be built without the iOS SDK, so only resolve
  buildPhase = ''
    runHook preBuild
    swift package --disable-sandbox resolve
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    for target in Capacitor Cordova; do
      cp ".build/artifacts/capacitor-swift-pm/$target/$target.xcframework/Info.plist" "$out/$target.plist"
    done
    runHook postInstall
  '';

  meta.platforms = lib.platforms.all;
})
