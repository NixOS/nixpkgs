{stdenv, fetchurl, python, pkgconfig, cairo, x11}:

stdenv.mkDerivation {
  name = "pycairo-1.8.8";
  src = fetchurl {
    url = http://cairographics.org/releases/pycairo-1.8.8.tar.gz;
    sha256 = "0q18hd4ai4raljlvd76ylgi30kxpr2qq83ka6gzwh0ya8fcmjlig";
  };

  buildInputs = [python pkgconfig cairo x11];
}
