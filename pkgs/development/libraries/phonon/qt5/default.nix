{ stdenv, fetchurl, cmake, mesa, pkgconfig, libpulseaudio
, qtbase, qtquick1, qttools
, debug ? false }:

with stdenv.lib;

let
  v = "4.8.3";
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/src/phonon-${v}.tar.xz";
    sha256 = "05nshngk03ln90vsjz44dx8al576f4vd5fvhs1l0jmx13jb9q551";
  };

  buildInputs = [ mesa qtbase qtquick1 qttools libpulseaudio ];

  nativeBuildInputs = [ cmake pkgconfig ];

  NIX_CFLAGS_COMPILE = "-fPIC";

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}"
    "-DPHONON_BUILD_PHONON4QT5=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
