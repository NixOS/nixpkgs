{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "freetype-2.3.7";
  
  src = fetchurl {
    url = mirror://sourceforge/freetype/freetype-2.3.7.tar.bz2;
    sha256 = "12787v5q083zwrpfh0sk87g4ac0yzzmjmw41k5k27hwznsg8gksf";
  };

  meta = {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
  };
}
