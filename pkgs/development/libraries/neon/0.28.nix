{ stdenv, fetchurl, libxml2
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, static ? false
, shared ? true
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

stdenv.mkDerivation rec {
  name = "neon-0.28.6";

  src = fetchurl {
    url = "http://www.webdav.org/neon/${name}.tar.gz";
    sha256 = "03ncisn1iziz79vw678wsrv8jf63m2szd2qml5baj53slcd8pvh6";
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
