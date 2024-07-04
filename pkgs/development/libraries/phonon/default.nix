{ stdenv
, lib
, fetchurl
, cmake
, libGLU
, libGL
, pkg-config
, libpulseaudio
, extra-cmake-modules
, qtbase
, qttools
, debug ? false
}:

let
  soname = "phonon4qt5";
  buildsystemdir = "share/cmake/${soname}";
in

stdenv.mkDerivation rec {
  pname = "phonon";
  version = "4.11.1";

  meta = {
    homepage = "https://community.kde.org/Phonon";
    description = "Multimedia API for Qt";
    mainProgram = "phononsettings";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ttuegel ];
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
    pkg-config
    extra-cmake-modules
  ];

  outputs = [ "out" "dev" ];

  env.NIX_CFLAGS_COMPILE = toString ([
    "-fPIC"
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-error=enum-constexpr-conversion"
  ]);

  cmakeBuildType = if debug then "Debug" else "Release";

  dontWrapQtApps = true;

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
