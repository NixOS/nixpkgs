{ stdenv
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
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${version}";
    sha256 = "0cy9l1vpsnfilxslvmn88hhq8iw8cnx3xpbnl78c0dgjyfv5xmhz";
  };

  patches = [
    ./udev-dir.patch
  ];

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

  meta = with stdenv.lib; {
    homepage = "https://www.indilib.org/";
    description = "Implementation of the INDI protocol for POSIX operating systems";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = [ "x86_64-linux" ];
  };
}
