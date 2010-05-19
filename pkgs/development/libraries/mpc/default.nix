{ fetchurl, stdenv, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "mpc-0.8.1";

  src = fetchurl {
    url = "http://www.multiprecision.org/mpc/download/${name}.tar.gz";
    sha256 = "1r73zqw8lnf0bkfsxn0znbwbfyacg94pd0l4aaixh7r5awvn0r76";
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
