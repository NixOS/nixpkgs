{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "freetype-2.1.5";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/freetype-2.1.5.tar.bz2;
    md5 = "54537b518b84d04190a1eccd393a29df";
#    url = http://cesnet.dl.sourceforge.net/sourceforge/freetype/freetype-2.1.7.tar.bz2;
#    md5 = "d71723948d7c0e44c401b5733c50857e";
  };
}
