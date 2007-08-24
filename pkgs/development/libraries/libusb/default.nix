{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libusb-0.1.12";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/libusb/libusb-0.1.12.tar.gz;
    md5 = "caf182cbc7565dac0fd72155919672e6";
  };
}
