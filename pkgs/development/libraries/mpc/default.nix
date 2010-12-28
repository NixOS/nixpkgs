{ fetchurl, stdenv, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "mpc-0.8.2";

  src = fetchurl {
    url = "http://www.multiprecision.org/mpc/download/${name}.tar.gz";
    sha256 = "1iw0ag28l5r88k7kpn6i89rqn3yhk2irqzk0d1mlb1la3paghydf";
  };

  buildInputs = [ gmp mpfr ];

  doCheck = true;

  meta = {
    description = "MPC, a library for multiprecision complex arithmetic with exact rounding";

    longDescription =
      '' MPC is a C library for the arithmetic of complex numbers with
         arbitrarily high precision and correct rounding of the result.  It is
         built upon and follows the same principles as GNU MPFR.
      '';

    homepage = http://mpc.multiprecision.org/;
    license = "LGPLv2+";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
