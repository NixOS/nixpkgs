{ fetchurl, stdenv, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "mpc-1.0.1";

  src = fetchurl {
    url = "http://www.multiprecision.org/mpc/download/${name}.tar.gz";
    sha256 = "ed5a815cfea525dc778df0cb37468b9c1b554aaf30d9328b1431ca705b7400ff";
  };

  buildInputs = [ gmp mpfr ];

  doCheck = true;

  meta = {
    description = "GNU MPC, a library for multiprecision complex arithmetic with exact rounding";

    longDescription =
      '' GNU MPC is a C library for the arithmetic of complex numbers with
         arbitrarily high precision and correct rounding of the result.  It is
         built upon and follows the same principles as GNU MPFR.
      '';

    homepage = http://mpc.multiprecision.org/;
    license = "LGPLv2+";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
