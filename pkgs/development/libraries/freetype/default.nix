{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "freetype-2.1.9";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/freetype/freetype-2.1.9.tar.bz2;
    md5 = "ec1b903e4be5f073caa72458ea58c29c";
  };
}
