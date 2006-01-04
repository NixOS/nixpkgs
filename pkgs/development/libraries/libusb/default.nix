{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libusb-0.1.10a";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/libusb/libusb-0.1.10a.tar.gz;
    md5 = "c6062b29acd2cef414bcc34e0decbdd1";
  };
}
