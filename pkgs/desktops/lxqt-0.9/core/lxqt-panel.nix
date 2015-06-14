{ stdenv, fetchgit, pkgconfig
, cmake
, libpthreadstubs
, libXcomposite
, libXdmcp
, qt54
, kguiaddons
, kwindowsystem
# lxqt dependencies
, libqtxdg
, liblxqt
, liblxqt-mount
, lxqt-globalkeys
, libsysstat
# optional lxqt dependencies
, menu-cache

# additional optional dependencies
, icu
, alsaLib
, pulseaudioFull
, lm_sensors
, libstatgrab

, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-panel";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "703a7aff3d5b7324fe6ef9f32527a24cda35b50f";
    sha256 = "3222e55a532e06358beea5c754e1f583d8372df0a1e673e7f5a59dbfd0f35068";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    libpthreadstubs libXcomposite libXdmcp
    qt54.base qt54.tools qt54.x11extras
    kguiaddons kwindowsystem
    libqtxdg liblxqt liblxqt-mount lxqt-globalkeys libsysstat
    menu-cache
    icu alsaLib pulseaudioFull lm_sensors libstatgrab
  ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Desktop panel";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
