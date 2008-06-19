{ stdenv, fetchurl, libxml2
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "neon-0.28.2";
  
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.28.2.tar.gz;
    sha256 = "154hzy2xa8a1dfdrjcggkik6dhpq1f5r1q2masrgysnv2cb61kfr";
  };
  
  buildInputs = [libxml2] ++ stdenv.lib.optional compressionSupport zlib;

  configureFlags = ''
    --enable-shared --disable-static
    ${if compressionSupport then "--with-zlib" else "--without-zlib"}
    ${if sslSupport then "--with-ssl --with-libs=${openssl}" else "--without-ssl"}
  '';

  passthru = {inherit compressionSupport sslSupport;};

  meta = {
    description = "An HTTP and WebDAV client library";
    homepage = http://www.webdav.org/neon/;
  };
}
