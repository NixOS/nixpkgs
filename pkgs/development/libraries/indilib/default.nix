{ stdenv, fetchurl, cmake, cfitsio, libusb, zlib, boost }:

stdenv.mkDerivation {
  name = "indilib-0.8";

  src = fetchurl {
    url = mirror://sourceforge/indi/libindi_0.8.tar.gz;
    sha256 = "d5ed14a5de6fd6e5db15463ada96c2b15b53e84a1ffe199b76f70128493f2a65";
  };

  propagatedBuildInputs = [ cmake cfitsio libusb zlib boost ];

  meta = {
    homepage = http://indi.sf.net;
  };
}
