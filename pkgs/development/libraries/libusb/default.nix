{stdenv, fetchurl, pkgconfig, libusb1}:

stdenv.mkDerivation {
  name = "libusb-compat-0.1.5";

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libusb1 ];

  src = fetchurl {
    url = mirror://sourceforge/libusb/libusb-compat-0.1.5.tar.bz2;
    sha256 = "0nn5icrfm9lkhzw1xjvaks9bq3w6mjg86ggv3fn7kgi4nfvg8kj0";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
