{ stdenv, fetchurl, libxml2, pkgconfig
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, static ? false
, shared ? true
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

let
   inherit (stdenv.lib) optionals;
in

stdenv.mkDerivation rec {
  version = "0.30.1";
  name = "neon-${version}";

  src = fetchurl {
    url = "http://www.webdav.org/neon/${name}.tar.gz";
    sha256 = "1pawhk02x728xn396a1kcivy9gqm94srmgad6ymr9l0qvk02dih0";
  };

  patches = optionals stdenv.isDarwin [ ./0.29.6-darwin-fix-configure.patch ];

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
