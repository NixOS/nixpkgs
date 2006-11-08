{ stdenv, fetchurl, libxml2
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;

(stdenv.mkDerivation {
  name = "neon-0.26.2";
  
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.26.2.tar.gz;
    md5 = "65ff7f6d962305b984a60d6ec5b189b5";
  };
  
  buildInputs = [libxml2] ++ (if compressionSupport then [zlib] else []);

  configureFlags="
    --enable-shared --disable-static
    ${if compressionSupport then "--with-zlib" else "--without-zlib"}
    ${if sslSupport then "--with-ssl --with-libs=${openssl}" else "--without-ssl"}
  ";
}) // {inherit compressionSupport sslSupport;}
