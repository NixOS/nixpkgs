{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.8.tar.gz;
    md5 = "9da21071596a124acde6080552deac16";
  };
  buildInputs = [perl];

  # Quick fix for a Makefile bug in openssl-0.9.8 (`make install'
  # tries to copy .so files, instead of .dylib files).
  patches = if stdenv.system == "powerpc-darwin" then [./dylib.patch] else [];
}
