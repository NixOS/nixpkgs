{ stdenv, fetchurl, libxml2
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, static ? false
, shared ? true
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

stdenv.mkDerivation {
  name = "neon-0.28.3";

  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.28.3.tar.gz;
    sha256 = "1hnd9wlbnfpppx6rvalhdkc1rf29afacl1m15z751g3h9hdybplh";
  };

  buildInputs = [libxml2] ++ stdenv.lib.optional compressionSupport zlib;

  configureFlags = ''
    ${if shared then "--enable-shared" else "--disable-shared"}
    ${if static then "--enable-static" else "--disable-static"}
    ${if compressionSupport then "--with-zlib" else "--without-zlib"}
    ${if sslSupport then "--with-ssl --with-libs=${openssl}" else "--without-ssl"}
    --enable-shared
  '';

  passthru = {inherit compressionSupport sslSupport;};

  meta = {
    description = "An HTTP and WebDAV client library";
    homepage = http://www.webdav.org/neon/;
  };
}
