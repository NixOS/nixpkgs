{
  lib,
  fetchFromGitHub,
  stdenv,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
  makeWrapper,
  aria2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcodes";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "XcodesOrg";
    repo = "xcodes";
    rev = finalAttrs.version;
    hash = "sha256-BUFcK+r7fDN7KC9PBikRGl355VouZ85ngcmVh7gj6tE=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    makeWrapper
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-jMJcW8vINSjfe7F3O7xaznZli2Vsi5QloXcI9itLUGQ=";
  };

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
      matteopacini
    ];
    platforms = lib.platforms.darwin;
  };
})
