{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.07"; # CLooG 0.16.3 fails to build with ISL 0.08.

  src = fetchurl {
    urls = [
        "http://www.kotnet.org/~skimo/isl/${name}.tar.bz2"
        "ftp://ftp.linux.student.kuleuven.be/pub/people/skimo/isl/${name}.tar.bz2"
      ];
    sha256 = "0kpxmvhrwwdygqqafqzjf9xiksq7paac2x24g9jhr3f9ajj3zkyx";
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
