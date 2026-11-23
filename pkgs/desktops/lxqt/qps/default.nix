{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "qps";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qps";
    rev = version;
    hash = "sha256-a2g2nZbfZT1/U23G1W11/ga7MCuT0RNo5bTvRCQ43c0=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/qps";
    description = "Qt based process manager";
    mainProgram = "qps";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux; # does not build on darwin
    teams = [ lib.teams.lxqt ];
  };
}
