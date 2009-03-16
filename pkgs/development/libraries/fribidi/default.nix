{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fribidi-0.10.9";
  
  src = fetchurl {
    url = http://fribidi.org/download/fribidi-0.10.9.tar.gz;
    sha256 = "1d479wbygqmxcsyg3g7d6nmzlaa3wngy21ci5qcc5nhbyn97bz5q";
  };

  meta = {
    homepage = http://fribidi.org/;
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
  };
}
