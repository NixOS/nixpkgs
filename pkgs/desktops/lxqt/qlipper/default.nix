{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kguiaddons,
  qtbase,
  qttools,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation {
  pname = "qlipper";
  version = "5.1.2-unstable-2025-10-29";

  src = fetchFromGitHub {
    owner = "pvanek";
    repo = "qlipper";
    rev = "4e9fcfe6684c465944baa153aeb7603ec27728b1";
    hash = "sha256-7qaLY3F67uBtX1wI667MaqtrKLDfeG9jKwlC1pUOteQ=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kguiaddons
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Cross-platform clipboard history applet";
    mainProgram = "qlipper";
    homepage = "https://github.com/pvanek/qlipper";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
  };
}
