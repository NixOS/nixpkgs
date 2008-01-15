{stdenv, fetchurl, m4}:

stdenv.mkDerivation {
  name = "gmp-4.2.2";

  src = fetchurl {
    url = mirror://gnu/gmp/gmp-4.2.2.tar.bz2;
    sha256 = "0yv593sk62ypn21gg2x570g955lmsi4i6f2bc3s43p52myn0lb1b";
  };

  buildInputs = [m4];

  doCheck = true;

  meta = {
    description = "A free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers";
    homepage = http://gmplib.org/;
    license = "LGPL";
  };
}
