{ stdenv, fetchurl, libxml2, pkgconfig
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, static ? false
, shared ? true
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

stdenv.mkDerivation rec {
  name = "neon-0.29.3";

  src = fetchurl {
    url = "http://www.webdav.org/neon/${name}.tar.gz";
    sha256 = "1d1c6zhr00yvg0fbhpkq8kmsq9cchr112ii9rl39gdybyflh9444";
  };

  buildInputs = [libxml2 pkgconfig openssl]
    ++ stdenv.lib.optional compressionSupport zlib;

  configureFlags = ''
    ${if shared then "--enable-shared" else "--disable-shared"}
    ${if static then "--enable-static" else "--disable-static"}
    ${if compressionSupport then "--with-zlib" else "--without-zlib"}
    ${if sslSupport then "--with-ssl" else "--without-ssl"}
    --enable-shared
  '';

  passthru = {inherit compressionSupport sslSupport;};

  meta = {
    description = "An HTTP and WebDAV client library";
    homepage = http://www.webdav.org/neon/;
  };
}
