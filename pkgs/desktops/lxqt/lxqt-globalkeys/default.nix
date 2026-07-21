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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-globalkeys";
    rev = version;
    hash = "sha256-VhySpJYHdi17U4yJBWXEWE2KEyG7AVcWYLpYXr2iCyc=";
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

  meta = {
    homepage = "https://github.com/lxqt/lxqt-globalkeys";
    description = "LXQt service for global keyboard shortcuts registration";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
}
