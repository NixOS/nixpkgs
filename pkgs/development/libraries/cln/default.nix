{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  pname = "cln";
  version = "1.3.5";

  src = fetchurl {
    url = "${meta.homepage}${pname}-${version}.tar.bz2";
    sha256 = "0bc43v4fyxwik9gjkvm8jan74bkx9bjssv61lfh9jhhblmj010bq";
  };

  buildInputs = [ gmp ];

  meta = with stdenv.lib; {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = https://www.ginac.de/CLN/;
    license = licenses.gpl2;
    platforms = platforms.unix; # Once had cygwin problems
  };
}
