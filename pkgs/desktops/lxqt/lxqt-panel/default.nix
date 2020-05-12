{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt-build-tools
, qtbase
, qttools
, qtx11extras
, qtsvg
, libdbusmenu
, kwindowsystem
, solid
, kguiaddons
, liblxqt
, libqtxdg
, lxqt-globalkeys
, libsysstat
, xorg
, libstatgrab
, lm_sensors
, libpulseaudio
, alsaLib
, menu-cache
, lxmenu-data
, pcre
, libXdamage
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-panel";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0k2gqf9f4g8fpny8p5m1anzk7mdxm9dgh6xlngz25nj4mshnq3xs";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    libdbusmenu
    kwindowsystem
    solid
    kguiaddons
    liblxqt
    libqtxdg
    lxqt-globalkeys
    libsysstat
    xorg.libpthreadstubs
    xorg.libXdmcp
    libstatgrab
    lm_sensors
    libpulseaudio
    alsaLib
    menu-cache
    lxmenu-data
    pcre
    libXdamage
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
