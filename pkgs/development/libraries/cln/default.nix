{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  pname = "cln";
  version = "1.3.6";

  src = fetchurl {
    url = "${meta.homepage}${pname}-${version}.tar.bz2";
    sha256 = "0jlq9l4hphk7qqlgqj9ihjp4m3rwjbhk6q4v00lsbgbri07574pl";
  };

  buildInputs = [ gmp ];

  meta = with stdenv.lib; {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = https://www.ginac.de/CLN/;
    license = licenses.gpl2;
    platforms = platforms.unix; # Once had cygwin problems
  };
}
