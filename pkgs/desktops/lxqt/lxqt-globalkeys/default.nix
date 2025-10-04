{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lxqt-build-tools,
  qtbase,
  qttools,
  qtsvg,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-globalkeys";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-globalkeys";
    rev = version;
    hash = "sha256-xVirPi0UD4lzOA1+Gw7SgUvFRIc1KYFUJtljNA7xAWo=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-globalkeys";
    description = "LXQt service for global keyboard shortcuts registration";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
