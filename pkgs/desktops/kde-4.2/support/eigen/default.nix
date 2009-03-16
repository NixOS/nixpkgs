{stdenv, fetchurl, cmake}:

stdenv.mkDerivation {
  name = "eigen-2.0.0";
  src = fetchurl {
    url = http://download.tuxfamily.org/eigen/eigen-2.0.0.tar.bz2;
    md5 = "bedfe344498b926a4b5db17d2846dbb5";
  };
  buildInputs = [ cmake ];  
}
