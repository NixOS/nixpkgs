{ stdenv, lib, fetchurl, cmake, libGLU_combined, pkgconfig, libpulseaudio
, qt4 ? null, extra-cmake-modules ? null, qtbase ? null, qttools ? null
, withQt5 ? false
, debug ? false }:

with lib;

let
  v = "4.10.2";

  soname = if withQt5 then "phonon4qt5" else "phonon";
  buildsystemdir = "share/cmake/${soname}";
in

assert withQt5 -> qtbase != null;
assert withQt5 -> qttools != null;

stdenv.mkDerivation rec {
  name = "phonon-${if withQt5 then "qt5" else "qt4"}-${v}";

  meta = {
    homepage = https://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/phonon-${v}.tar.xz";
    sha256 = "02c8fyyvg5qb0lxwxmnxc5grkg6p3halakjf02vmwmvqaycb3v9l";
  };

  buildInputs =
    [ libGLU_combined libpulseaudio ]
    ++ (if withQt5 then [ qtbase qttools ] else [ qt4 ]);

  nativeBuildInputs =
    [ cmake pkgconfig ]
    ++ optional withQt5 extra-cmake-modules;

  outputs = [ "out" "dev" ];

  NIX_CFLAGS_COMPILE = "-fPIC";

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}" ]
    ++ optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";

  preConfigure = ''
    cmakeFlags+=" -DPHONON_QT_MKSPECS_INSTALL_DIR=''${!outputDev}/mkspecs"
    cmakeFlags+=" -DPHONON_QT_IMPORTS_INSTALL_DIR=''${!outputBin}/$qtQmlPrefix"
    cmakeFlags+=" -DPHONON_QT_PLUGIN_INSTALL_DIR=''${!outputBin}/$qtPluginPrefix/designer"
  '';

  postPatch = ''
    sed -i PhononConfig.cmake.in \
        -e "/get_filename_component(rootDir/ s/^.*$//" \
        -e "/^set(PHONON_INCLUDE_DIR/ s|\''${rootDir}/||" \
        -e "/^set(PHONON_LIBRARY_DIR/ s|\''${rootDir}/||" \
        -e "/^set(PHONON_BUILDSYSTEM_DIR/ s|\''${rootDir}|''${!outputDev}|"

    sed -i cmake/FindPhononInternal.cmake \
        -e "/set(INCLUDE_INSTALL_DIR/ c set(INCLUDE_INSTALL_DIR \"''${!outputDev}/include\")"

    ${optionalString withQt5 ''
    sed -i cmake/FindPhononInternal.cmake \
        -e "/set(PLUGIN_INSTALL_DIR/ c set(PLUGIN_INSTALL_DIR \"$qtPluginPrefix/..\")"
    ''}

    sed -i CMakeLists.txt \
        -e "/set(BUILDSYSTEM_INSTALL_DIR/ c set(BUILDSYSTEM_INSTALL_DIR \"''${!outputDev}/${buildsystemdir}\")"
  '';

  postFixup = ''
    sed -i "''${!outputDev}/lib/pkgconfig/${soname}.pc" \
        -e "/^exec_prefix=/ c exec_prefix=''${!outputBin}/bin"
  '';
}
