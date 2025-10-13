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
  version = "5.1.2-unstable-2025-07-04";

  src = fetchFromGitHub {
    owner = "pvanek";
    repo = "qlipper";
    rev = "d3e605fb9d44c523a95e3aac53c7d179a560c85f";
    hash = "sha256-9V9s0oxWKqd9MHKlkZF3SetrAjHX4cAenAg7as4TLn0=";
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

  meta = with lib; {
    description = "Cross-platform clipboard history applet";
    mainProgram = "qlipper";
    homepage = "https://github.com/pvanek/qlipper";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
  };
}
