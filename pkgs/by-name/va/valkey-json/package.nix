{
  cmake,
  fetchFromGitHub,
  lib,
  rapidjson,
  stdenv,
  valkey,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "valkey-json";
  version = "1.0.2-unstable-2026-06-09";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey-json";
    rev = "8ff1f53b7db9a5d69c716b6b4a6bdb4fefc63a9e";
    hash = "sha256-mOn/Y121sC8vTnPTxYnM4DAW9INvgrHeOvXY3gyPrUQ=";
  };

  patches = [
    ./external-libs.patch
  ];

  cmakeFlags = [
    (lib.cmakeFeature "VALKEY_SERVER_PATH" "${valkey}/bin/valkey-server")
    (lib.cmakeFeature "VALKEY_MODULE_H_PATH" "${valkey.src}/src/valkeymodule.h")
    (lib.cmakeBool "ENABLE_UNIT_TESTS" false)
    (lib.cmakeBool "ENABLE_INTEGRATION_TESTS" false)
  ];

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=implicit-const-int-float-conversion";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ rapidjson ];

  installPhase = ''
    mkdir -p $out/lib
    cp src/libjson.* $out/lib
  '';

  meta = {
    changelog = "https://github.com/valkey-io/valkey-json/blob/${finalAttrs.version}/00-RELEASENOTES";
    description = "Module which provides native JSON support for Valkey";
    homepage = "https://github.com/valkey-io/valkey-json";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
