{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  libxdmcp,
  liblxqt,
  libpthread-stubs,
  libqtxdg,
  lxqt-build-tools,
  pkg-config,
  procps,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  qtxdg-tools,
  wrapQtAppsHook,
  xdg-user-dirs,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-session";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-session";
    rev = version;
    hash = "sha256-5VJxRho6qdPvBFr0RkYaajvVZRwhc1emzqpII+lUyOQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    layer-shell-qt
    libxdmcp
    liblxqt
    libpthread-stubs
    libqtxdg
    procps
    qtbase
    qtsvg
    qtwayland
    qtxdg-tools
    xdg-user-dirs
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-session";
    description = "Alternative session manager ported from the original razor-session";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
}
