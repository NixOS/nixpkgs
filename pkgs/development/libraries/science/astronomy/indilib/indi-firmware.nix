{
  stdenv,
  lib,
  bash,
  cmake,
  cfitsio,
  coreutils,
  libusb1,
  zlib,
  boost,
  libnova,
  curl,
  libjpeg,
  gsl,
  fftw,
  indilib,
  libgphoto2,
  libraw,
  libftdi1,
  libdc1394,
  gpsd,
  ffmpeg,
  version,
  src,
  autoPatchelfHook,
}:
let
  libusb-with-fxload = libusb1.override { withExamples = true; };
in
stdenv.mkDerivation rec {
  pname = "indi-firmware";

  inherit version src;

  nativeBuildInputs = [
    cmake
    autoPatchelfHook
  ];

  buildInputs = [
    indilib
    libnova
    curl
    cfitsio
    libusb1
    zlib
    boost
    gsl
    gpsd
    libjpeg
    libgphoto2
    libraw
    libftdi1
    libdc1394
    ffmpeg
    fftw
  ];

  cmakeFlags = [
    "-DINDI_DATA_DIR=\${CMAKE_INSTALL_PREFIX}/share/indi"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DRULES_INSTALL_DIR=lib/udev/rules.d"
    "-DFIRMWARE_INSTALL_DIR=lib/firmware"
    "-DQHY_FIRMWARE_INSTALL_DIR=\${CMAKE_INSTALL_PREFIX}/lib/firmware/qhy"
    "-DCONF_DIR=etc"
    "-DBUILD_LIBS=1"
    "-DWITH_PENTAX=off"
    "-DWITH_AHP_XC=off"
  ];

  postPatch = ''
    for f in {libfishcamp,libsbig,libqhy}/CMakeLists.txt
    do
      substituteInPlace $f --replace "/lib/firmware" "lib/firmware"
    done
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    for f in $out/lib/udev/rules.d/*.rules
    do
      substituteInPlace "$f" --replace "/sbin/fxload" "${libusb-with-fxload}/sbin/fxload" \
                             --replace "/bin/sleep" "${coreutils}/bin/sleep" \
                             --replace "/bin/cat" "${coreutils}/bin/cat" \
                             --replace "/bin/echo" "${coreutils}/bin/echo" \
                             --replace "/bin/sh" "${bash}/bin/sh" \
                             --replace "/lib/firmware/" "$out/lib/firmware/"
      sed -e 's|-D $env{DEVNAME}|-p $env{BUSNUM},$env{DEVNUM}|' -i "$f"
    done
  '';

  meta = with lib; {
    homepage = "https://www.indilib.org/";
    description = "Third party firmware for the INDI astronomical software suite";
    changelog = "https://github.com/indilib/indi-3rdparty/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      hjones2199
      sheepforce
    ];
    platforms = platforms.linux;
  };
}
