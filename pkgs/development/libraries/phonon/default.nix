{ stdenv, fetchurl, cmake, mesa, pkgconfig, libpulseaudio
, qt4 ? null, automoc4 ? null
, qtbase ? null, qtquick1 ? null, qttools ? null
, debug ? false }:

with stdenv.lib;

let
  v = "4.8.3";
  withQt5 = qtbase != null;
in

assert withQt5 -> qtquick1 != null;
assert withQt5 -> qttools != null;
assert !withQt5 -> automoc4 != null;

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/src/phonon-${v}.tar.xz";
    sha256 = "05nshngk03ln90vsjz44dx8al576f4vd5fvhs1l0jmx13jb9q551";
  };

  buildInputs =
    [ mesa libpulseaudio ]
    ++ (if withQt5 then [ qtbase qtquick1 qttools ] else [ qt4 ]);

  nativeBuildInputs =
    [ cmake pkgconfig ]
    ++ optional (!withQt5) automoc4;

  NIX_CFLAGS_COMPILE = "-fPIC";

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}" ]
    ++ optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";

  postPatch = ''
    sed -i PhononConfig.cmake.in \
        -e "/get_filename_component(rootDir/ s/^.*$//" \
        -e "s,\\(set(PHONON_INCLUDE_DIR\\).*$,\\1 \"''${!outputDev}/include\")," \
        -e "s,\\(set(PHONON_LIBRARY_DIR\\).*$,\\1 \"''${!outputLib}/lib\")," \
        -e "s,\\(set(PHONON_BUILDSYSTEM_DIR\\).*$,\\1 \"''${!outputDev}/share/phonon${if withQt5 then "4qt5" else ""}/buildsystem\"),"
  '';
}
