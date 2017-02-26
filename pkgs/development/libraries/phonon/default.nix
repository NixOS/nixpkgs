{ stdenv, lib, fetchurl, cmake, mesa, pkgconfig, libpulseaudio
, qt4 ? null, extra-cmake-modules ? null, qtbase ? null, qttools ? null
, withQt5 ? false
, debug ? false }:

with lib;

let
  v = "4.9.0";
in

assert withQt5 -> qtbase != null;
assert withQt5 -> qttools != null;

stdenv.mkDerivation rec {
  name = "phonon-${if withQt5 then "qt5" else "qt4"}-${v}";

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/phonon-${v}.tar.xz";
    sha256 = "1q5hvsk4sfcb91625wcmldy7kgjmfpmpmkgzi6mxkqdd307v8x5v";
  };

  buildInputs =
    [ mesa libpulseaudio ]
    ++ (if withQt5 then [ qtbase qttools ] else [ qt4 ]);

  nativeBuildInputs =
    [ cmake pkgconfig ]
    ++ optional withQt5 extra-cmake-modules;

  NIX_CFLAGS_COMPILE = "-fPIC";

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}" ]
    ++ optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";

  postPatch = ''
    sed -i PhononConfig.cmake.in \
        -e "/get_filename_component(rootDir/ s/^.*$//" \
        -e "/^set(PHONON_INCLUDE_DIR/ s,\''${rootDir},''${!outputDev}," \
        -e "/^set(PHONON_LIBRARY_DIR/ s,\''${rootDir}/,," \
        -e "/^set(PHONON_BUILDSYSTEM_DIR/ s,\''${rootDir},''${!outputDev},"
  '';
}
