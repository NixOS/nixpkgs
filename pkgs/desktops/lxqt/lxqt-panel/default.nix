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

stdenv.mkDerivation rec {
  pname = "lxqt-panel";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-panel";
    rev = version;
    hash = "sha256-ui+HD2igPiyIOgIKPbgfO4dnfm2rFP/R6oG2pH5g5VY=";
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

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-panel";
    description = "LXQt desktop panel";
    mainProgram = "lxqt-panel";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
