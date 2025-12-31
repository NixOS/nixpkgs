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
  version = "1.18.0";

  src = fetchurl {
    url = "https://github.com/ngtcp2/ngtcp2/releases/download/v${finalAttrs.version}/ngtcp2-${finalAttrs.version}.tar.bz2";
    hash = "sha256-E7r7bFCdv2pw2WBaLIkuE/WuuTZnOZWHeKhXvHDOH6c=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    brotli
    nghttp3
    openssl
  ]
  # libev is only needed for example programs; when building library-only
  # (e.g. on MinGW) avoid pulling it in.
  ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [
    libev
  ]
  ++ lib.optional withJemalloc jemalloc;

  cmakeFlags = [
    # The examples try to link against `ngtcp2_crypto_ossl` and `ngtcp2` libraries.
    # This works in the dynamic case where the targets have the same name, but not here where they're suffixed with `_static`.
    # Also, the examples depend on Linux-specific APIs, so we avoid them on FreeBSD/Cygwin too.
    (lib.cmakeBool "ENABLE_LIB_ONLY" (
      stdenv.hostPlatform.isStatic
      || stdenv.hostPlatform.isFreeBSD
      || stdenv.hostPlatform.isCygwin
      || stdenv.hostPlatform.isMinGW
    ))
    (lib.cmakeBool "ENABLE_SHARED_LIB" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ENABLE_STATIC_LIB" stdenv.hostPlatform.isStatic)
  ];

  doCheck = !stdenv.hostPlatform.isMinGW;

  passthru.tests = {
    inherit curl;
  };

  meta = {
    homepage = "https://github.com/ngtcp2/ngtcp2";
    changelog = "https://github.com/ngtcp2/ngtcp2/releases/tag/v${finalAttrs.version}";
    description = "Implementation of the QUIC protocol (RFC9000)";
    license = lib.licenses.mit;
    # MSYS2 ships ngtcp2 for mingw-w64, and nixpkgs' MinGW curl depends on it.
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
