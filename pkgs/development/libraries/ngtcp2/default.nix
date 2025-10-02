{
  lib,
  stdenv,
  fetchurl,
  cmake,
  brotli,
  libev,
  nghttp3,
  openssl,
  withJemalloc ? false,
  jemalloc,
  curl,
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
    openssl
  ]
  ++ lib.optional withJemalloc jemalloc;

  cmakeFlags =
    if stdenv.hostPlatform.isStatic then
      [
        # The examples try to link against `ngtcp2_crypto_ossl` and `ngtcp2` libraries.
        # This works in the dynamic case where the targets have the same name, but not here where they're suffixed with `_static`.
        (lib.cmakeBool "ENABLE_LIB_ONLY" true)
        (lib.cmakeBool "ENABLE_SHARED_LIB" false)
        (lib.cmakeBool "ENABLE_STATIC_LIB" true)
      ]
    else
      [
        (lib.cmakeBool "ENABLE_STATIC_LIB" false)
      ];

  doCheck = true;

  passthru.tests = {
    inherit curl;
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
