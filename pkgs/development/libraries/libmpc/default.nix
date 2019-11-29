{ stdenv, fetchurl
, gmp, mpfr
}:

let
  version = "1.1.0";
in
stdenv.mkDerivation {
  pname = "libmpc";
  inherit version; # to avoid clash with the MPD client

  src = fetchurl {
    url = "mirror://gnu/mpc/mpc-${version}.tar.gz";
    sha256 = "0biwnhjm3rx3hc0rfpvyniky4lpzsvdcwhmcn7f0h4iw2hwcb1b9";
  };

  buildInputs = [ gmp mpfr ];

  doCheck = true; # not cross;

  meta = {
    description = "Library for multiprecision complex arithmetic with exact rounding";

    longDescription =
      '' GNU MPC is a C library for the arithmetic of complex numbers with
         arbitrarily high precision and correct rounding of the result.  It is
         built upon and follows the same principles as GNU MPFR.
      '';

    homepage = http://mpc.multiprecision.org/;
    license = stdenv.lib.licenses.lgpl2Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
