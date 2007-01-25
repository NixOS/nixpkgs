{ stdenv, fetchurl, libxml2
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;

(stdenv.mkDerivation {
  name = "neon-0.26.3";
  
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.26.3.tar.gz;
    sha256 = "0gvv5a5z0fmfhdvz5qb1zb1z30jlml1y03hjzg8dn9246nw7z2dn";
  };
  
  buildInputs = [libxml2] ++ (if compressionSupport then [zlib] else []);

  configureFlags="
    --enable-shared --disable-static
    ${if compressionSupport then "--with-zlib" else "--without-zlib"}
    ${if sslSupport then "--with-ssl --with-libs=${openssl}" else "--without-ssl"}
  ";
}) // {inherit compressionSupport sslSupport;}
