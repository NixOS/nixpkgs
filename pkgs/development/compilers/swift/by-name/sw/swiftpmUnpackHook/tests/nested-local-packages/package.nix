{
  lib,
  stdenv,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "test-swiftpm-nested-local-packages";
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
    hash = "sha256-6ZfXw/Qod2aQk3ZYSTyORUi0DAJcat3dqnZb9oPn/sA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp "$(swiftpmBinPath)/nested" "$out/bin/"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    [ "$("$out/bin/nested")" = "1.2.3" ]
    runHook postInstallCheck
  '';

  meta.platforms = lib.platforms.all;
})
