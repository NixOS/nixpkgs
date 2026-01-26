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

stdenv.mkDerivation (finalAttrs: {
  pname = "screengrab";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "screengrab";
    tag = finalAttrs.version;
    hash = "sha256-LORWv3qLgQF2feKodOg72g5DCfWZvB8vi0bw9jbr+tQ=";
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

  meta = {
    homepage = "https://github.com/lxqt/screengrab";
    description = "Crossplatform tool for fast making screenshots";
    mainProgram = "screengrab";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
})
