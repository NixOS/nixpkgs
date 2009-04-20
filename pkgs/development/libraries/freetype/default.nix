{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "freetype-2.3.9";
  
  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "1dia4j01aqdcrkpfkcniswcrccdx4jx2p3hyhbh76kchx6y3782i";
  };

  meta = {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
  };
}
