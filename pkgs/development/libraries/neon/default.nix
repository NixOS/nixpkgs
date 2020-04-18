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
  version = "0.31.0";
  pname = "neon";

  src = fetchurl {
    url = "http://www.webdav.org/neon/${pname}-${version}.tar.gz";
    sha256 = "19dx4rsqrck9jl59y4ad9jf115hzh6pz1hcl2dnlfc84hc86ymc0";
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

  meta = with stdenv.lib; {
    description = "An HTTP and WebDAV client library";
    homepage = "http://www.webdav.org/neon/";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
