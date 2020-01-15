{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  pname = "cln";
  version = "1.3.4";

  src = fetchurl {
    url = "${meta.homepage}${pname}-${version}.tar.bz2";
    sha256 = "0j5p18hwbbrchsdbnc8d2bf9ncslhflri4i950gdnq7v6g2dg69d";
  };

  buildInputs = [ gmp ];

  meta = with stdenv.lib; {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = http://www.ginac.de/CLN/;
    license = licenses.gpl2;
    platforms = platforms.unix; # Once had cygwin problems
  };
}
