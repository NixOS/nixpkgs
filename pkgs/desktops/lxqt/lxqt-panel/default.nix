{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, alsaLib
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
, lxqtUpdateScript
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
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1mm23fys5npm5fi47y3h2mzvlhlcaz7k1p4wwmc012f0hqcrvqik";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    alsaLib
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
    xorg.libpthreadstubs
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "The LXQt desktop panel";
    homepage = "https://github.com/lxqt/lxqt-panel";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
