{
  lib,
  fetchFromGitHub,
  swiftPackages,
  swift,
  swiftpm,
  swiftpm2nix,
  makeWrapper,
  aria2,
}:
let
  generated = swiftpm2nix.helpers ./generated;
  stdenv = swiftPackages.stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xcodes";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "XcodesOrg";
    repo = "xcodes";
    rev = finalAttrs.version;
    hash = "sha256-TwPfASRU98rifyA/mINFfoY0MbbwmAh8JneVpJa38CA=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    makeWrapper
  ];

  configurePhase = generated.configure;

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    install -D $binPath/xcodes $out/bin/xcodes
    wrapProgram $out/bin/xcodes \
      --prefix PATH : ${lib.makeBinPath [ aria2 ]}

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/XcodesOrg/xcodes/releases/tag/${finalAttrs.version}";
    description = "Command-line tool to install and switch between multiple versions of Xcode";
    homepage = "https://github.com/XcodesOrg/xcodes";
    license = with lib.licenses; [
      mit
      # unxip
      lgpl3Only
    ];
    maintainers = with lib.maintainers; [
      _0x120581f
      emilytrau
    ];
    platforms = lib.platforms.darwin;
  };
})
