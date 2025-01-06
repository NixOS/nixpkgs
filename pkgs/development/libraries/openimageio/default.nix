{ lib, stdenv
, fetchFromGitHub
, boost
, cmake
, giflib
, libjpeg
, libpng
, libtiff
, opencolorio
, openexr
, robin-map
, unzip
, fmt
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "2.5.15.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenImageIO";
    rev = "v${version}";
    hash = "sha256-jtX6IDR/yFn10hf+FxM0s4St9XYxhQ1UlMAsNzOxuio=";
  };

  # Workaround broken zlib version detecion in CMake < 3.37.
  postPatch = ''
    substituteInPlace ./src/cmake/Config.cmake.in \
      --replace " @ZLIB_VERSION@" ""
  '';

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    boost
    giflib
    libjpeg
    libpng
    libtiff
    opencolorio
    openexr
    robin-map
  ];

  propagatedBuildInputs = [
    fmt
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
    "-DUSE_QT=OFF"
    # GNUInstallDirs
    "-DCMAKE_INSTALL_LIBDIR=lib" # needs relative path for pkg-config
    # Do not install a copy of fmt header files
    "-DINTERNALIZE_FMT=OFF"
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenImageIO/OpenImageIOTargets-*.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$out/lib/lib"
  '';

  meta = with lib; {
    homepage = "https://openimageio.org";
    description = "Library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
