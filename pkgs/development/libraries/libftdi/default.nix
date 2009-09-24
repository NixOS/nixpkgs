{stdenv, fetchurl, libusb}:

stdenv.mkDerivation rec {
  name = "libftdi-0.16";
  
  src = fetchurl {
    url = "http://www.intra2net.com/en/developer/libftdi/download/${name}.tar.gz";
    sha256 = "1n12lcvpzmkph12gmg7i7560s0yly2gjgwhxh2h2inq93agg1xv2";
  };

  buildInputs = [ libusb ];

  propagatedBuildInputs = [ libusb ];

  meta = {
    description = "A library to talk to FTDI chips using libusb";
    homepage = http://www.intra2net.com/en/developer/libftdi/;
    license = "LGPLv2.1";
  };
}
