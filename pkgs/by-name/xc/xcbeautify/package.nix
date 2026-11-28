{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcbeautify";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "cpisciotta";
    repo = "xcbeautify";
    tag = finalAttrs.version;
    hash = "sha256-CfAj3/cjgvc2HBKoH9evF3Ou6DVHLJut7WctgWsPUJc=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/rzS/7y3FJgcw/rRrpnnixZy1CDDok8dZt/Xtr2/JGw=";
  };

  installPhase = ''
    runHook preInstall

    install -D "$(swiftpmBinPath)/xcbeautify" "$out/bin/xcbeautify"

    runHook postInstall
  '';

  meta = {
    description = "Little beautifier tool for xcodebuild";
    homepage = "https://github.com/cpisciotta/xcbeautify";
    changelog = "https://github.com/cpisciotta/xcbeautify/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "xcbeautify";
    maintainers = with lib.maintainers; [
      siddarthkay
      shgew
    ];
  };
})
