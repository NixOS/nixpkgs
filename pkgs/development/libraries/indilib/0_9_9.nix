{ stdenv, fetchurl, cmake, cfitsio, libusb1, zlib, boost, libnova, libjpeg, gsl, pkgconfig }:

stdenv.mkDerivation {
  name = "indilib-0.9.9";

  src = fetchurl {
    url = mirror://sourceforge/indi/libindi_0.9.9.tar.gz;
    sha256 = "720b9096baef1489fd7d7d4a236177863a7f7cec86809f21d291b0d9758e4039";
  };

  propagatedBuildInputs = [ cfitsio libusb1 zlib boost libnova libjpeg gsl ];
  nativeBuildInputs = [ cmake pkgconfig ];

  preConfigure = ''
    cmakeFlags+=" -DUDEVRULES_INSTALL_DIR=$out/etc/udev/rules.d"
  '';

  meta = {
    homepage = http://indi.sf.net;
  };
}
