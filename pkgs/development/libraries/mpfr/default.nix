{stdenv, fetchurl, gmp}:

stdenv.mkDerivation {
  name = "mpfr-2.3.2";

  src = fetchurl {
    url = http://www.mpfr.org/mpfr-current/mpfr-2.3.2.tar.bz2;
    sha256 = "0k5s5whhz5njp4ybim8c7rcin5ba1s2apwijmg7bg0p1jv4piq0q";
  };

  buildInputs = [gmp];

  meta = {
    homepage = http://www.mpfr.org/;
    description = "Library for multiple-precision floating-point arithmetic";
  };
}
