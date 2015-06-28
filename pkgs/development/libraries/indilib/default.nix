{ stdenv, fetchurl, cmake, cfitsio, libusb, zlib, boost, libnova
, libjpeg, gsl }:

stdenv.mkDerivation {
  name = "indilib-1.0.0";

  src = fetchurl {
    url = mirror://sourceforge/indi/libindi_1.0.0.tar.gz;
    sha256 = "0f66jykpjk8mv50lc3rywbqj9mqr4p2n1igfb1222h5fs83c1jhm";
  };

  patches = [ ./udev-dir.patch ] ;

  propagatedBuildInputs = [ cmake cfitsio libusb zlib boost
                            libnova libjpeg gsl ];

  meta = {
    homepage = http://indi.sf.net;
  };
}
