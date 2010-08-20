{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "cln-1.3.1";

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.bz2";
    sha256 = "1sd8jy5vnmww537zq6g6i586ffslm7fjliz04krv6scapgklq6ca";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = http://www.ginac.de/CLN/;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
