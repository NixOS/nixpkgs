{ stdenv, lib, fetchurl, cmake, phonon, pkgconfig, vlc
, extra-cmake-modules, qtbase ? null, qtx11extras ? null, qt4 ? null
, withQt4 ? false
, debug ? false
}:

with lib;

let
  v = "0.10.2";
  pname = "phonon-backend-vlc";
in

assert withQt4 -> qt4 != null;
assert !withQt4 -> qtbase != null;
assert !withQt4 -> qtx11extras != null;

stdenv.mkDerivation {
  name = "${pname}-${if withQt4 then "qt4" else "qt5"}-${v}";

  meta = with stdenv.lib; {
    homepage = https://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl2Plus ];
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${v}/${pname}-${v}.tar.xz";
    sha256 = "163jqq5p9n0yfw2fqk0cqn3c6mqycxsvc4956zhkw5345g81a2a9";
  };

  buildInputs =
    [ phonon vlc ]
    ++ (if withQt4 then [ qt4 ] else [ qtbase qtx11extras ]);

  nativeBuildInputs = [ cmake pkgconfig ] ++ optional (!withQt4) extra-cmake-modules;

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}" ]
    ++ optional (!withQt4) "-DPHONON_BUILD_PHONON4QT5=ON";
}
