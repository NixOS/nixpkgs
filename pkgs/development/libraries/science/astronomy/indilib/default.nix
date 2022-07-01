{ stdenv
, lib
, fetchFromGitHub
, cmake
, cfitsio
, libusb1
, zlib
, boost
, libnova
, curl
, libjpeg
, gsl
, fftw
}:

stdenv.mkDerivation rec {
  pname = "indilib";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${version}";
    sha256 = "sha256-mj9rnPn85Fbc7Y8qRndqPVANzBrk3al+vDJagLTDJ04=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    curl
    cfitsio
    libusb1
    zlib
    boost
    libnova
    libjpeg
    gsl
    fftw
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
  ];

  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    changelog = "https://github.com/indilib/indi/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.linux;
  };
}
