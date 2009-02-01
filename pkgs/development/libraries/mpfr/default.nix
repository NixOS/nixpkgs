{stdenv, fetchurl, gmp}:

stdenv.mkDerivation {
  name = "mpfr-2.4.0";

  src = fetchurl {
    urls = [
      http://gforge.inria.fr/frs/download.php/16015/mpfr-2.4.0.tar.bz2
      http://www.mpfr.org/mpfr-2.4.0/mpfr-2.4.0.tar.bz2
    ];
    sha256 = "17ajw12jfs721igsr6ny3wxz9j1nm618iplc82wyzins5gn52gdy";
  };

  buildInputs = [gmp];

  meta = {
    homepage = http://www.mpfr.org/;
    description = "Library for multiple-precision floating-point arithmetic";
  };
}
