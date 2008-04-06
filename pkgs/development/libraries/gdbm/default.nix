{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gdbm-1.8.3";
  src = fetchurl {
    url = "mirror://gnu/gdbm/${name}.tar.gz";
    sha256 = "1j8x51xc71di1fx23sl22n5ghlqxl9a57sxri82l12z2l8w06d6c";
  };

  patches = [ ./install.patch ];

  meta = {
    description = "GNU DBM key/value database library";
    homepage = http://www.gnu.org/software/gdbm/;
    license = "GPLv2+";
  };
}
