{stdenv, fetchurl, pkgconfig, libusb}:

stdenv.mkDerivation {
  name = "libgphoto2-2.1.99";

  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/gphoto/libgphoto2-2.1.99.tar.bz2;
    md5 = "3c6d9cb65661915e07491a6f9215d5a9";
  };
  buildInputs = [pkgconfig libusb];
}
