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
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0f3sjzkria61nz342daxps2w57wnx6laq9iww8hha7rbi24yw2sd";
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
