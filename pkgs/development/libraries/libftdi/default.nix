{stdenv, fetchurl, libusb}:

stdenv.mkDerivation rec {
  name = "libftdi-0.17";
  
  src = fetchurl {
    url = "http://www.intra2net.com/en/developer/libftdi/download/${name}.tar.gz";
    sha256 = "1w5bzq4h4v9qah9dx0wbz6w7ircr91ack0sh6wqs8s5b4m8jgh6m";
  };

  buildInputs = [ libusb ];

  propagatedBuildInputs = [ libusb ];

  meta = {
    description = "A library to talk to FTDI chips using libusb";
    homepage = http://www.intra2net.com/en/developer/libftdi/;
    license = "LGPLv2.1";
  };
}
