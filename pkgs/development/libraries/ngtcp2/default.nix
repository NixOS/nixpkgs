{
  lib,
  stdenv,
  fetchurl,
  cmake,
  brotli,
  libev,
  nghttp3,
  quictls,
  withJemalloc ? false,
  jemalloc,
  curlHTTP3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ngtcp2";
  version = "1.15.1";

  src = fetchurl {
    url = "https://github.com/ngtcp2/ngtcp2/releases/download/v${finalAttrs.version}/ngtcp2-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Bbf6cvldAd3fvDVuHL89VPx1h1wvY2CGW5gIsDNM75c=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    brotli
    libev
    nghttp3
    quictls
  ]
  ++ lib.optional withJemalloc jemalloc;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_STATIC_LIB" false)
  ];

  doCheck = true;

  passthru.tests = {
    inherit curlHTTP3;
  };

  meta = {
    homepage = "https://github.com/ngtcp2/ngtcp2";
    changelog = "https://github.com/ngtcp2/ngtcp2/releases/tag/v${finalAttrs.version}";
    description = "Implementation of the QUIC protocol (RFC9000)";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
