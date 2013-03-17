{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.11.1"; # CLooG 0.16.3 fails to build with ISL 0.08.

  src = fetchurl {
    urls = [
        "http://www.kotnet.org/~skimo/isl/${name}.tar.bz2"
        "ftp://ftp.linux.student.kuleuven.be/pub/people/skimo/isl/${name}.tar.bz2"
      ];
    sha256 = "095f4b54c88ca13a80d2b025d9c551f89ea7ba6f6201d701960bfe5c1466a98d";
  };

  buildInputs = [ gmp ];

  meta = {
    homepage = http://www.kotnet.org/~skimo/isl/;
    license = "LGPLv2.1";
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.all;
  };
}
