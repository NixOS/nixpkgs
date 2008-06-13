{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "freetype-2.3.6";
  
  src = fetchurl {
    url = mirror://sourceforge/freetype/freetype-2.3.6.tar.bz2;
    sha256 = "0xqf24d42qj5x8h6cmwpdqg455kpcbaxc3jlwqf4rlbn0g1ri9nm";
  };

  meta = {
    description = "A font engine";
    homepage = http://www.freetype.org/;
  };
}
