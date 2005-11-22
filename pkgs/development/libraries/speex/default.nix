{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "speex-1.0.5";
  src = fetchurl {
    url = http://downloads.us.xiph.org/releases/speex/speex-1.0.5.tar.gz;
    md5 = "01d6a2de0a88a861304bf517615dea79";
  };
}
