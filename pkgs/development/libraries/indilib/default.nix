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
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi";
    rev = "v${version}";
    sha256 = "1yzvcm7lwhwssnvv6gp8f7igmnvs35bpidmzz6z15awm5841yw30";
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
