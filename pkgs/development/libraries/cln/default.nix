{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "cln-1.3.3";

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.bz2";
    sha256 = "04i6kdjwm4cr5pa70pilifnpvsh430rrlapkgw1x8c5vxkijxz2p";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = http://www.ginac.de/CLN/;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = with stdenv.lib.platforms; allBut cygwin;
  };
}
