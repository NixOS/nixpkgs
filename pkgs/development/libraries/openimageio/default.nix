{ lib, stdenv
, fetchFromGitHub
, boost
, cmake
, giflib
, ilmbase
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
<<<<<<< HEAD
  version = "2.4.15.0";
=======
  version = "2.4.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-I2/JPmUBDb0bw7qbSZcAkYHB2q2Uo7En7ZurMwWhg/M=";
=======
    hash = "sha256-YWVKmvUHq1QSpTCP0UBfSxqWTIWjxOF0gVE7qljCOyY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    boost
    giflib
    ilmbase
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
