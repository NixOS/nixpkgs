{ stdenv, fetchurl, libxml2, pkgconfig, perl
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
  version = "0.30.2";
  name = "neon-${version}";

  src = fetchurl {
    url = "http://www.webdav.org/neon/${name}.tar.gz";
    sha256 = "1jpvczcx658vimqm7c8my2q41fnmjaf1j03g7bsli6rjxk6xh2yv";
  };

  patches = optionals stdenv.isDarwin [ ./0.29.6-darwin-fix-configure.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [libxml2 openssl]
    ++ stdenv.lib.optional compressionSupport zlib;

  configureFlags = [
    (stdenv.lib.enableFeature shared "shared")
    (stdenv.lib.enableFeature static "static")
    (stdenv.lib.withFeature compressionSupport "zlib")
    (stdenv.lib.withFeature sslSupport "ssl")
  ];

  passthru = {inherit compressionSupport sslSupport;};

  checkInputs = [ perl ];
  doCheck = false; # fails, needs the net

  meta = {
    description = "An HTTP and WebDAV client library";
    homepage = http://www.webdav.org/neon/;
    platforms = stdenv.lib.platforms.unix;
  };
}
