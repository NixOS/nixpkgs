{
  lib, mkDerivation, fetchFromGitHub,
  cmake, pkgconfig, lxqt-build-tools,
  qtbase, qttools, qtx11extras, qtsvg, libdbusmenu, kwindowsystem, solid,
  kguiaddons, liblxqt, libqtxdg, lxqt-globalkeys, libsysstat,
  xorg, libstatgrab, lm_sensors, libpulseaudio, alsaLib, menu-cache,
  lxmenu-data, pcre, libXdamage
}:

mkDerivation rec {
  pname = "lxqt-panel";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1py3i7qgm6h2iwjwqfjml1rp06s7ls1d7z5i9iizsmfshdzkaq86";
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

  meta = with lib; {
    description = "The LXQt desktop panel";
    homepage = https://github.com/lxqt/lxqt-panel;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
