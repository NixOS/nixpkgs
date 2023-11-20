{ stdenv
, lib
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
, limesuite
, version
, src
, withFirmware ? false
, firmware ? null
}:

stdenv.mkDerivation rec {
  pname = "indi-3rdparty";

  inherit version src;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    indilib libnova curl cfitsio libusb1 zlib boost gsl gpsd
    libjpeg libgphoto2 libraw libftdi1 libdc1394 ffmpeg fftw
    limesuite
  ] ++ lib.optionals withFirmware [
    firmware
  ];

  postPatch = ''
    for f in $(find . -name "CMakeLists.txt"); do
      substituteInPlace $f \
        --replace "/lib/udev/rules.d" "lib/udev/rules.d" \
        --replace "/etc/udev/rules.d" "lib/udev/rules.d" \
        --replace "/lib/firmware" "lib/firmware"
    done

    substituteInPlace libpktriggercord/CMakeLists.txt \
      --replace "set (PK_DATADIR /usr/share/pktriggercord)" "set (PK_DATADIR $out/share/pkgtriggercord)"

    sed '1i#include <ctime>' -i indi-duino/libfirmata/src/firmata.cpp # gcc12
  '';

  cmakeFlags = [
    "-DINDI_DATA_DIR=share/indi"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DRULES_INSTALL_DIR=lib/udev/rules.d"
  ] ++ lib.optionals (!withFirmware) [
    "-DWITH_ATIK=off"
    "-DWITH_APOGEE=off"
    "-DWITH_DSI=off"
    "-DWITH_QHY=off"
    "-DWITH_ARMADILLO=off"
    "-DWITH_FISHCAMP=off"
    "-DWITH_SBIG=off"
  ];

  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Third party drivers for the INDI astronomical software suite";
    changelog = "https://github.com/indilib/indi-3rdparty/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 sheepforce ];
    platforms = platforms.linux;
  };
}
