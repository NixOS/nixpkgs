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
<<<<<<< HEAD
, limesuite
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    limesuite
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals withFirmware [
    firmware
  ];

  postPatch = ''
<<<<<<< HEAD
    for f in $(find . -name "CMakeLists.txt"); do
=======
    for f in indi-qsi/CMakeLists.txt \
             indi-dsi/CMakeLists.txt \
             indi-armadillo-platypus/CMakeLists.txt \
             indi-orion-ssg3/CMakeLists.txt
    do
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      substituteInPlace $f \
        --replace "/lib/udev/rules.d" "lib/udev/rules.d" \
        --replace "/etc/udev/rules.d" "lib/udev/rules.d" \
        --replace "/lib/firmware" "lib/firmware"
    done

<<<<<<< HEAD
    substituteInPlace libpktriggercord/CMakeLists.txt \
      --replace "set (PK_DATADIR /usr/share/pktriggercord)" "set (PK_DATADIR $out/share/pkgtriggercord)"

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sed '1i#include <ctime>' -i indi-duino/libfirmata/src/firmata.cpp # gcc12
  '';

  cmakeFlags = [
    "-DINDI_DATA_DIR=share/indi"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DRULES_INSTALL_DIR=lib/udev/rules.d"
<<<<<<< HEAD
  ] ++ lib.optionals (!withFirmware) [
    "-DWITH_ATIK=off"
=======
    # Pentax, Atik, and SX cmakelists are currently broken
    "-DWITH_PENTAX=off"
    "-DWITH_ATIK=off"
    "-DWITH_SX=off"
  ] ++ lib.optionals (!withFirmware) [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ hjones2199 sheepforce ];
=======
    maintainers = with maintainers; [ hjones2199 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
