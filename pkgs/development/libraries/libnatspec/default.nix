{ stdenv, fetchurl, popt, libiconv }:

stdenv.mkDerivation (rec {
  name = "libnatspec-0.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/natspec/${name}.tar.bz2";
    sha256 = "0zvm9afh1skxgdv62ylrpwyykpjhhskxj0zv7yrdf7jhfdriz0y3";
  };

  buildInputs = [ popt ];

  meta = {
    homepage = http://natspec.sourceforge.net/ ;
    description = "A library intended to smooth national specificities in using of programs";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
} // stdenv.lib.optionalAttrs (!stdenv.isLinux) {
  NIX_CFLAGS_COMPILE = "-I${libiconv}/include";

  NIX_CFLAGS_LINK = "-L${libiconv}/lib -liconv";
})
