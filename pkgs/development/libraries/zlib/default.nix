{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "zlib-1.2.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/zlib-1.2.2.tar.gz;
    md5 = "68bd51aaa6558c3bc3fd4890e53413de";
  };
  configureFlags = "--shared";
}
