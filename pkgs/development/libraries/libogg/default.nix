{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libogg-1.1.2";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/ogg/libogg-1.1.2.tar.gz ;
    md5 = "4d82996517bf33bb912c97e9d0b635c4" ;
  };
}
