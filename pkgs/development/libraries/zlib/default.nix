{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "zlib-1.2.1";
  src = fetchurl {
    url = http://www.gzip.org/zlib/zlib-1.2.1.tar.gz;
    md5 = "ef1cb003448b4a53517b8f25adb12452";
  };
  configureFlags = "--shared";
}
