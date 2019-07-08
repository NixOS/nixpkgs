{ stdenv, fetchurl, cmake, cfitsio, libusb, zlib, boost, libnova
, curl, libjpeg, gsl }:

stdenv.mkDerivation {
  name = "indilib-1.1.0";

  src = fetchurl {
    url = mirror://sourceforge/indi/libindi_1.1.0.tar.gz;
    sha256 = "1bs6lkwqd4aashg93mqqkc7nrg7fbx9mdw85qs5263jqa6sr780w";
  };

  patches = [ ./udev-dir.patch ] ;

  buildInputs = [ curl cmake cfitsio libusb zlib boost
                            libnova libjpeg gsl ];

  meta = {
    homepage = https://www.indilib.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    description = "Implementaion of the INDI protocol for POSIX operating systems";
    platforms = stdenv.lib.platforms.unix;
  };
}
