{ stdenv, fetchurl, cmake, cfitsio, libusb, zlib, boost, libnova
, libjpeg, gsl }:
let
  version = "1.0.0";
in
stdenv.mkDerivation {
  name = "indilib-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/libi/libindi/libindi_${version}.orig.tar.gz";
      #"mirror://sourceforge/indi/libindi_${version}.tar.gz" # 1.0.0 not there anymore
    sha256 = "0f66jykpjk8mv50lc3rywbqj9mqr4p2n1igfb1222h5fs83c1jhm";
  };

  patches = [ ./udev-dir.patch ] ;

  propagatedBuildInputs = [ cmake cfitsio libusb zlib boost
                            libnova libjpeg gsl ];

  meta = {
    homepage = http://indi.sf.net;
  };
}
