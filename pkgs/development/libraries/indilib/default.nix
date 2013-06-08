{ stdenv, fetchurl, cmake, cfitsio, libusb, zlib, boost }:

stdenv.mkDerivation {
  name = "indilib-0.9.6";

  src = fetchurl {
    url = mirror://sourceforge/indi/libindi_0.9.6.tar.gz;
    sha256 = "1cyhsrsl68iczc4gcdnrrdh0r1dxjac6prxjfkw15wz97ya0mvs4";
  };

  patches = [ ./link-zlib.patch ./udev-dir.patch ];

  propagatedBuildInputs = [ cmake cfitsio libusb zlib boost ];

  meta = {
    homepage = http://indi.sf.net;
  };
}
