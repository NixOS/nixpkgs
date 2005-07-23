{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "zlib-1.2.3";
  src = fetchurl {
    url = http://www.zlib.net/zlib-1.2.3.tar.gz;
    md5 = "debc62758716a169df9f62e6ab2bc634";
  };
  configureFlags = "--shared";
}
