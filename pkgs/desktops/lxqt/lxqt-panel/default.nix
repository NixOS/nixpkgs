{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  libdbusmenu-lxqt,
  kguiaddons,
  kwindowsystem,
  layer-shell-qt,
  libxdamage,
  libxdmcp,
  libxtst,
  libdbusmenu,
  liblxqt,
  libpthread-stubs,
  libpulseaudio,
  libqtxdg,
  libstatgrab,
  libsysstat,
  lm_sensors,
  lxqt-build-tools,
  lxqt-globalkeys,
  lxqt-menu-data,
  pcre2,
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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-panel";
    tag = finalAttrs.version;
    hash = "sha256-TExmFE02GDRWWHCzJNETSY5GbOXxxX1OFFrEe9krBqM=";
  };

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
    libxdamage
    libxdmcp
    libxtst
    libdbusmenu
    liblxqt
    libpthread-stubs
    libpulseaudio
    libqtxdg
    libstatgrab
    libsysstat
    lm_sensors
    lxqt-globalkeys
    lxqt-menu-data
    pcre2
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
