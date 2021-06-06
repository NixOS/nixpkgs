{ lib, stdenv, fetchurl, libxml2, pkg-config, perl
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, static ? false
, shared ? true
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

let
   inherit (lib) optionals;
in

stdenv.mkDerivation rec {
  version = "0.29.6";
  pname = "neon";

  src = fetchurl {
    url = "http://www.webdav.org/neon/${pname}-${version}.tar.gz";
    sha256 = "0hzbjqdx1z8zw0vmbknf159wjsxbcq8ii0wgwkqhxj3dimr0nr4w";
  };

  patches = optionals stdenv.isDarwin [ ./0.29.6-darwin-fix-configure.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [libxml2 openssl]
    ++ lib.optional compressionSupport zlib;

  configureFlags = [
    (lib.enableFeature shared "shared")
    (lib.enableFeature static "static")
    (lib.withFeature compressionSupport "zlib")
    (lib.withFeature sslSupport "ssl")
  ];

  passthru = {inherit compressionSupport sslSupport;};

  checkInputs = [ perl ];
  doCheck = false; # fails, needs the net

  meta = with lib; {
    description = "An HTTP and WebDAV client library";
    homepage = "http://www.webdav.org/neon/";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
