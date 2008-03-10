{stdenv, fetchurl, liboil, pkgconfig}:

stdenv.mkDerivation {
  name = "schroedinger-1.0.0";
  src = fetchurl {
    url = mirror://sourceforge/schrodinger/schroedinger-1.0.0.tar.gz;
    sha256 = "0r374wvc73pfzkcpwk0q0sjx6yhp79acyiqbjy3c7sfqdy7sm4x8";
  };

  buildInputs = [liboil pkgconfig];
}
