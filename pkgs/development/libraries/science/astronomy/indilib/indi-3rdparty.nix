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
, indilib
, libgphoto2
, libraw
, libftdi1
, libdc1394
, gpsd
, ffmpeg
}:

stdenv.mkDerivation rec {
  pname = "indi-3rdparty";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = pname;
    rev = "v${version}";
    sha256 = "0klvknhp7l6y2ab4vyv4jq7znk1gjl5b3709kyplm7dsh4b8bppy";
  };

  cmakeFlags = [
    "-DINDI_DATA_DIR=\${CMAKE_INSTALL_PREFIX}/share/indi"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DWITH_SX=off"
    "-DWITH_SBIG=off"
    "-DWITH_APOGEE=off"
    "-DWITH_FISHCAMP=off"
    "-DWITH_DSI=off"
    "-DWITH_QHY=off"
    "-DWITH_ARMADILLO=off"
    "-DWITH_PENTAX=off"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    indilib libnova curl cfitsio libusb1 zlib boost gsl gpsd
    libjpeg libgphoto2 libraw libftdi1 libdc1394 ffmpeg fftw
  ];

  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Third party drivers for the INDI astronomical software suite";
    changelog = "https://github.com/indilib/indi-3rdparty/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.linux;
  };
}
