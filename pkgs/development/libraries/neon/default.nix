{ lib, stdenv, fetchurl, libxml2, pkg-config
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, static ? stdenv.hostPlatform.isStatic
, shared ? !stdenv.hostPlatform.isStatic
, bash
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert static || shared;

let
   inherit (lib) optionals;
in

stdenv.mkDerivation rec {
  version = "0.32.5";
  pname = "neon";

  src = fetchurl {
    url = "https://notroj.github.io/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-SHLhL4Alct7dSwL4cAZYFLLVFB99va9wju2rgmtRpYo=";
  };

  patches = optionals stdenv.isDarwin [ ./darwin-fix-configure.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [libxml2 openssl bash]
    ++ lib.optional compressionSupport zlib;

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature shared "shared")
    (lib.enableFeature static "static")
    (lib.withFeature compressionSupport "zlib")
    (lib.withFeature sslSupport "ssl")
  ];

  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  passthru = {inherit compressionSupport sslSupport;};

  meta = with lib; {
    description = "An HTTP and WebDAV client library";
    mainProgram = "neon-config";
    homepage = "https://notroj.github.io/neon/";
    changelog = "https://github.com/notroj/${pname}/blob/${version}/NEWS";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
