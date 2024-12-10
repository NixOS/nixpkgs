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
  menu-cache,
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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-IlT7qXWMKFkmHNjXJYivawd4HnOBzILtIE6XaM/ZvkM=";
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
    menu-cache
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
    maintainers = teams.lxqt.members;
  };
}
