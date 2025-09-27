{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  qttools,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "qlipper";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "pvanek";
    repo = "qlipper";
    rev = version;
    hash = "sha256-wHhaRtNiNCk5dtO2dVjRFDVicmYtrnCb2twx6h1m834=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
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
