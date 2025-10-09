{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoPatchelfHook,
  gitUpdater,
  kwindowsystem,
  layer-shell-qt,
  libXdmcp,
  libpthreadstubs,
  libqtxdg,
  lxqt-build-tools,
  perl,
  pkg-config,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "screengrab";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "screengrab";
    rev = version;
    hash = "sha256-6cGj3Ijv4DsAdJjcHKUg5et+yYc5miIHHZOTD2D9ASk=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    pkg-config
    perl # needed by LXQtTranslateDesktop.cmake
    qttools
    autoPatchelfHook # fix libuploader.so and libextedit.so not found
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    layer-shell-qt
    libXdmcp
    libpthreadstubs
    libqtxdg
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/screengrab";
    description = "Crossplatform tool for fast making screenshots";
    mainProgram = "screengrab";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
