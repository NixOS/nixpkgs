{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  qt5,
  rustPlatform,
  protobuf,
  buildPackages,
  sqlcipher,
  cmake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "whisperfish";
  version = "0-unstable-2026-07-16";

  src = fetchFromGitLab {
    owner = "whisperfish";
    repo = "whisperfish";
    rev = "99b5228701a0ad1f4140ca618af4b12bc7318be3";
    hash = "sha256-VDiFFGRL2bYWeSL2jjr/lukWchqwnvYbN19KYyZs2mE=";
  };

  cargoHash = "sha256-esKiJomSgpzrZLuOcWi4/eg9/o5+2HtFTmQObQoYn3Q=";

  env.QMAKE = "${qt5.qtbase.dev}/bin/qmake";

  preBuild = ''
    export PROTOC=${buildPackages.protobuf}/bin/protoc
  '';

  cargoBuildFlags = [ "--workspace" ];

  nativeBuildInputs = [
    pkg-config
    qt5.qtbase
    qt5.wrapQtAppsHook
    protobuf
    cmake
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtimageformats
    qt5.qtmultimedia
    qt5.qtsvg
    qt5.qttools
    protobuf
    sqlcipher
    qt5.qtwayland
  ];

  preFixup = ''
    qtWrapperArgs+=(--unset QT_STYLE_OVERRIDE)
  '';

  meta = {
    description = "Signal client originally for Sailfish OS";
    homepage = "https://gitlab.com/whisperfish/whisperfish";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.onny ];
    platforms = lib.platforms.all;
    mainProgram = "harbour-whisperfish";
  };
})
