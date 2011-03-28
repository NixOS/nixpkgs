{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "fribidi-${version}";
  version = "0.19.2";
  
  src = fetchurl {
    url = "http://fribidi.org/download/${name}.tar.gz";
    sha256 = "0xs1yr22zw9a1qq9ygsrqam0vzqdvb0ndzvjb3i2zda8drc93ks9";
  };

  meta = {
    homepage = http://fribidi.org/;
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
  };
}
