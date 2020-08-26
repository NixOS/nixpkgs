{ stdenv
, lib
, fetchurl
, cmake
, libGLU
, libGL
, pkgconfig
, libpulseaudio
, extra-cmake-modules
, qtbase
, qttools
, debug ? false
}:

with lib;

let
  soname = "phonon4qt5";
  buildsystemdir = "share/cmake/${soname}";
in

stdenv.mkDerivation rec {
  pname = "phonon";
  version = "4.11.1";

  meta = {
    homepage = "https://phonon.kde.org/";
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${version}/phonon-${version}.tar.xz";
    sha256 = "0bfy8iqmjhlg3ma3iqd3kxjc2zkzpjgashbpf5x17y0dc2i1whxl";
  };

  buildInputs = [
    libGLU
    libGL
    libpulseaudio
    qtbase
    qttools
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    extra-cmake-modules
  ];

  outputs = [ "out" "dev" ];

  NIX_CFLAGS_COMPILE = "-fPIC";

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else "Release"}"
  ];

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

    sed -i cmake/FindPhononInternal.cmake \
        -e "/set(PLUGIN_INSTALL_DIR/ c set(PLUGIN_INSTALL_DIR \"$qtPluginPrefix/..\")"

    sed -i CMakeLists.txt \
        -e "/set(BUILDSYSTEM_INSTALL_DIR/ c set(BUILDSYSTEM_INSTALL_DIR \"''${!outputDev}/${buildsystemdir}\")"
  '';

  postFixup = ''
    sed -i "''${!outputDev}/lib/pkgconfig/${soname}.pc" \
        -e "/^exec_prefix=/ c exec_prefix=''${!outputBin}/bin"
  '';
}
