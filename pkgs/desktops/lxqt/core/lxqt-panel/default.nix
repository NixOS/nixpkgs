{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg,
libstatgrab, lm_sensors, libpulseaudio, alsaLib, menu-cache,
lxmenu-data }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-panel";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0lwgz6nir4cd50xbmc3arngnw38rb5kqgcsgp3dlq6gpncg45hdq";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    qt5.libdbusmenu
    kde5.kwindowsystem
    kde5.solid
    kde5.kguiaddons
    lxqt.liblxqt
    lxqt.libqtxdg
    lxqt.lxqt-globalkeys
    lxqt.libsysstat
    xorg.libpthreadstubs
    xorg.libXdmcp
    libstatgrab
    lm_sensors
    libpulseaudio
    alsaLib
    menu-cache
    lxmenu-data
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = lxqt.standardPatch;

  meta = with stdenv.lib; {
    description = "The LXQt desktop panel";
    homepage = https://github.com/lxde/lxqt-panel;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
