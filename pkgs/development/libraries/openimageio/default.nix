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
  version = "2.5.5.0";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "v${version}";
    hash = "sha256-FtUZqk1m9ahdnwhrBeMFkUbV0dangMY/w9ShevCASfo=";
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
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}
