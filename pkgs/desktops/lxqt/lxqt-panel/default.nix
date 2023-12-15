{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, kguiaddons
, kwindowsystem
, libXdamage
, libdbusmenu
, liblxqt
, libpulseaudio
, libqtxdg
, libstatgrab
, libsysstat
, lm_sensors
, lxqt-build-tools
, lxqt-globalkeys
, lxqt-menu-data
, gitUpdater
, menu-cache
, pcre
, qtbase
, qtsvg
, qttools
, qtx11extras
, solid
, xorg
}:

mkDerivation rec {
  pname = "lxqt-panel";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-LQq1XOA0dGXXORVr2H/gI+axvCAd4P3nB4zCFYWgagc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    alsa-lib
    kguiaddons
    kwindowsystem
    libXdamage
    libdbusmenu
    liblxqt
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
    qtx11extras
    solid
    xorg.libXdmcp
    xorg.libXtst
    xorg.libpthreadstubs
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-panel";
    description = "The LXQt desktop panel";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
