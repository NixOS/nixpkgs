{ fetchgit
, stdenv
, meson
, ninja
, cmake
, pkgconfig
, gobject-introspection
, gtk3
, glib
, xorg
, xdotool
, xrdesktop
}:

stdenv.mkDerivation rec {
  pname = "libinputsynth";
  version = xrdesktop.version;
  
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/xrdesktop/libinputsynth.git";
    rev = version;
    sha256 = "0j6nxg6581c1s0dhl5d67dk7i8jrafmk829vp43j03ny5aajw8qy";
  };
  
  patches = [
    ./0001-fix-xdo.patch
  ];
  
  propagatedBuildInputs = [
    gtk3
    glib
    xorg.libXtst
    xorg.libX11
    xorg.libXi
    xdotool
  ];
  
  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkgconfig
    gobject-introspection
  ];
}
