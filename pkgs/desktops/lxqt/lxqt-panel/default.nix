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
, lxmenu-data
, lxqt-build-tools
, lxqt-globalkeys
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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "tSj7GGIvneYapkyqqgSMJtPGApC1fdpiId2XgQF5xf0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
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
    lxmenu-data
    lxqt-globalkeys
    menu-cache
    pcre
    qtbase
    qtsvg
    qttools
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
