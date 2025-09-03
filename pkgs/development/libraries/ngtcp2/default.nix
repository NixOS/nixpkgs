{
  lib,
  stdenv,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = "ngtcp2";
    # must match version usage in meta.changelog
    tag = "v${finalAttrs.version}";
    hash = "sha256-336khLt6LGxdctX7u3u8TVqN1EQjl+Gyz/44+bpatms=";
    fetchSubmodules = true;
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
