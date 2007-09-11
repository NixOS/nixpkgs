{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libogg-1.1.3";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/ogg/libogg-1.1.3.tar.gz;
    md5 = "eaf7dc6ebbff30975de7527a80831585";
  };
}
