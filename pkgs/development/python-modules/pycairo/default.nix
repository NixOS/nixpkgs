{stdenv, fetchurl, python, pkgconfig, cairo, x11}:

stdenv.mkDerivation {
  name = "pycairo-1.4.0";
  src = fetchurl {
    url = http://cairographics.org/releases/pycairo-1.4.0.tar.gz;
    sha256 = "0cky2iw3ccbqh96y5ypbrxmmaj1jmdcmlss0k6p3jzkjxvzsy4lj";
  };

  buildInputs = [python pkgconfig cairo x11];
}
