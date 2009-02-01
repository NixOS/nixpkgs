{stdenv, fetchurl, m4, cxx ? true}:

stdenv.mkDerivation {
  name = "gmp-4.2.4";

  src = fetchurl {
    url = mirror://gnu/gmp/gmp-4.2.4.tar.bz2;
    sha256 = "0s73xzhwrfqcr1gmhsink1fhfzjlkyk70b1bdyrm76m6b3jv082l";
  };

  buildInputs = [m4];
  
  configureFlags = if cxx then "--enable-cxx" else "--disable-cxx";
  
  doCheck = true;

  meta = {
    description = "A free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers";
    homepage = http://gmplib.org/;
    license = "LGPL";
  };
}
