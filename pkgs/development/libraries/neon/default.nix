{ stdenv, fetchurl, libxml2
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;

(stdenv.mkDerivation {
  name = "neon-0.25.5";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/neon-0.25.5.tar.gz;
    md5 = "b5fdb71dd407f0a3de0f267d27c9ab17";
  };
  
  buildInputs = [libxml2] ++ (if compressionSupport then [zlib] else []);

  configureFlags="
    --enable-shared --disable-static
    ${if compressionSupport then "--with-zlib" else "--without-zlib"}
    ${if sslSupport then "--with-ssl --with-libs=${openssl}" else "--without-ssl"}
  ";
}) // {inherit compressionSupport sslSupport;}
