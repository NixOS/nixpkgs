{
  stdenv, fetchFromGitHub, fetchpatch, standardPatch,
  cmake, pkgconfig, lxqt-build-tools,
  qtbase, qttools, qtx11extras, qtsvg, libdbusmenu, kwindowsystem, solid,
  kguiaddons, liblxqt, libqtxdg, lxqt-common, lxqt-globalkeys, libsysstat,
  xorg, libstatgrab, lm_sensors, libpulseaudio, alsaLib, menu-cache,
  lxmenu-data
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-panel";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "097rivly61i99v0w9a3dgbwbc4c5x9nh3jl0n94dix1qgd4w983y";
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
    lxqt-common
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
  ];

  patches = [
    (fetchpatch {
       url = https://github.com/lxde/lxqt-panel/commit/ec62109e0fa678875a9b10fc6f1975267432712d.patch;
       name = "fix-compile-explicit-keyword.patch";
       sha256 = "1grda0dw175kbsfq90lr5qaf79akwikzxw85jhd5f339nnramp81";
    })
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = standardPatch;

  meta = with stdenv.lib; {
    description = "The LXQt desktop panel";
    homepage = https://github.com/lxde/lxqt-panel;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
