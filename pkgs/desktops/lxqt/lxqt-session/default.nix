{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  libXdmcp,
  liblxqt,
  libpthreadstubs,
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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-AwL7X8ygBkVINMCEcyImUrbwmk/T6/fwk0PEEu6iBb8=";
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
    libXdmcp
    liblxqt
    libpthreadstubs
    libqtxdg
    procps
    qtbase
    qtsvg
    qtwayland
    qtxdg-tools
    xdg-user-dirs
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-session";
    description = "Alternative session manager ported from the original razor-session";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
