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
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "indilib";
    repo = pname;
    rev = "v${version}";
    sha256 = "18ii9qsghrvj8y4y6c7bx6kjradybnmyq8i5phj7pv4r8w91rq7g";
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
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = [ "x86_64-linux" ];
  };
}
