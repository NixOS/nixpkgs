{ fetchurl, stdenv, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "mpc-0.9";

  src = fetchurl {
    url = "http://www.multiprecision.org/mpc/download/${name}.tar.gz";
    sha1 = "229722d553030734d49731844abfef7617b64f1a";
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
