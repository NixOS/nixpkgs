{ lib, stdenv, fetchurl, libxml2, pkg-config, perl
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, static ? stdenv.hostPlatform.isStatic
, shared ? !stdenv.hostPlatform.isStatic
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

let
   inherit (lib) optionals;
in

stdenv.mkDerivation rec {
  version = "0.31.0";
  pname = "neon";

  src = fetchurl {
    url = "http://www.webdav.org/neon/${pname}-${version}.tar.gz";
    sha256 = "19dx4rsqrck9jl59y4ad9jf115hzh6pz1hcl2dnlfc84hc86ymc0";
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
