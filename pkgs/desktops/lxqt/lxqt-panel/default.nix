{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  alsa-lib,
  libdbusmenu-lxqt,
  kguiaddons,
  kwindowsystem,
  layer-shell-qt,
  libXdamage,
  libXdmcp,
  libXtst,
  libdbusmenu,
  liblxqt,
  libpthreadstubs,
  libpulseaudio,
  libqtxdg,
  libstatgrab,
  libsysstat,
  lm_sensors,
  lxqt-build-tools,
  lxqt-globalkeys,
  lxqt-menu-data,
  pcre,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  solid,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-panel";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-panel";
    tag = finalAttrs.version;
    hash = "sha256-ui+HD2igPiyIOgIKPbgfO4dnfm2rFP/R6oG2pH5g5VY=";
  };

  patches = [
    # fix build against Qt >= 6.10 (https://github.com/lxqt/lxqt-panel/pull/2306)
    # TODO: drop when upgrading beyond version 2.2.2
    (fetchpatch {
      name = "cmake-fix-build-with-Qt-6.10.patch";
      url = "https://github.com/lxqt/lxqt-panel/commit/fce8cd99a1de0e637e8539c4d8ac68832a40fa6d.patch";
      hash = "sha256-KXxV6SZqdpvZSn+zbBZ32Qs6XKfFXEej1F4qBt+MzxA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    libdbusmenu-lxqt
    kguiaddons
    kwindowsystem
    layer-shell-qt
    libXdamage
    libXdmcp
    libXtst
    libdbusmenu
    liblxqt
    libpthreadstubs
    libpulseaudio
    libqtxdg
    libstatgrab
    libsysstat
    lm_sensors
    lxqt-globalkeys
    lxqt-menu-data
    pcre
    qtbase
    qtsvg
    qtwayland
    solid
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-panel";
    description = "LXQt desktop panel";
    mainProgram = "lxqt-panel";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
})
