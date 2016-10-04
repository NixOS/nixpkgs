{ stdenv, lib, fetchurl, cmake, phonon, pkgconfig, vlc
, extra-cmake-modules, qtbase ? null, qtx11extras ? null, qt4 ? null
, withQt5 ? false
, debug ? false
}:

with lib;

let
  v = "0.9.0";
  pname = "phonon-backend-vlc";
in

assert withQt5 -> qtbase != null;
assert withQt5 -> qtx11extras != null;

stdenv.mkDerivation rec {
  name = "${pname}-${if withQt5 then "qt5" else "qt4"}-${v}";

  meta = with stdenv.lib; {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${v}/${pname}-${v}.tar.xz";
    sha256 = "1gnd1j305mqajw5gxm42vg6ajkvi8611bxgc3qhj5k0saz5dgkn0";
  };

  buildInputs =
    [ phonon vlc ]
    ++ (if withQt5 then [ qtbase qtx11extras ] else [ qt4 ]);

  nativeBuildInputs = [ cmake pkgconfig ] ++ optional withQt5 extra-cmake-modules;

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}" ]
    ++ optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";
}
