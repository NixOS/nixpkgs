{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "screengrab";
    tag = finalAttrs.version;
    hash = "sha256-6cGj3Ijv4DsAdJjcHKUg5et+yYc5miIHHZOTD2D9ASk=";
  };

  patches = [
    # fix build against Qt >= 6.10 (https://github.com/lxqt/screengrab/pull/434)
    # TODO: drop when upgrading beyond version 3.0.0
    (fetchpatch {
      name = "cmake-fix-build-with-Qt-6.10.patch";
      url = "https://github.com/lxqt/screengrab/commit/1621ef5df9461cdd1dcef3faee36e9419f1ca08c.patch";
      hash = "sha256-+rpCDLnHmgy/1PME3QaN+978W+jR6PDmiZ/5hAx8Djg=";
    })
  ];

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
