{ fetchurl, stdenv, gmp, mpfr }:
let
  version = "1.0.3";
in
stdenv.mkDerivation rec {
  name = "libmpc-${version}"; # to avoid clash with the MPD client

  src = fetchurl {
    url = "http://www.multiprecision.org/mpc/download/mpc-${version}.tar.gz";
    sha256 = "1hzci2zrrd7v3g1jk35qindq05hbl0bhjcyyisq9z209xb3fqzb1";
  };

  buildInputs = [ gmp mpfr ];

  CFLAGS = "-I${gmp.dev}/include";

  doCheck = true;

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

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
