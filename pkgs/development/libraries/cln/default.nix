{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "cln-${version}";
  version = "1.3.4";

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.bz2";
    sha256 = "0j5p18hwbbrchsdbnc8d2bf9ncslhflri4i950gdnq7v6g2dg69d";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = http://www.ginac.de/CLN/;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = with stdenv.lib.platforms; allBut cygwin;
  };
}
