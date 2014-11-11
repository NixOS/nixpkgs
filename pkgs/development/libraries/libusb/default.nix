{stdenv, fetchurl, pkgconfig, libusb1}:

stdenv.mkDerivation {
  name = "libusb-compat-0.1.5";

  buildInputs = [ pkgconfig libusb1 ];

  src = fetchurl {
    url = mirror://sourceforge/libusb/libusb-compat-0.1.5.tar.bz2;
    sha256 = "0nn5icrfm9lkhzw1xjvaks9bq3w6mjg86ggv3fn7kgi4nfvg8kj0";
  };
}
