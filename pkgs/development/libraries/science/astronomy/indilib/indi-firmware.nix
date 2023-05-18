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
, version
, src
}:

stdenv.mkDerivation rec {
  pname = "indi-firmware";

  inherit version src;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    indilib libnova curl cfitsio libusb1 zlib boost gsl gpsd
    libjpeg libgphoto2 libraw libftdi1 libdc1394 ffmpeg fftw
  ];

  cmakeFlags = [
    "-DINDI_DATA_DIR=\${CMAKE_INSTALL_PREFIX}/share/indi"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DFIRMWARE_INSTALL_DIR=\${CMAKE_INSTALL_PREFIX}/lib/firmware"
    "-DCONF_DIR=etc"
    "-DBUILD_LIBS=1"
    "-DWITH_PENTAX=off"
  ];

  postPatch = ''
    for f in {libfishcamp,libsbig,libqhy}/CMakeLists.txt
    do
      substituteInPlace $f --replace "/lib/firmware" "lib/firmware"
    done
  '';

  postFixup = ''
    rm $out/lib/udev/rules.d/99-fli.rules
  '';

  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Third party firmware for the INDI astronomical software suite";
    changelog = "https://github.com/indilib/indi-3rdparty/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.linux;
  };
}
