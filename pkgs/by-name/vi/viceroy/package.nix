{
  lib,
  rustc,
  rustPlatform,
  fetchFromGitHub,
  symlinkJoin,
  pkg-config,
  aws-lc,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viceroy";
  version = "0.22.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "viceroy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OhYC0otFIuntokCfDjRlOKsiN5QUL/MdW/0thjDOWIQ=";
  };

  # build.rs compiles component adapter for wasm32-unknown-unknown from wasm_abi/adapter
  # which is in a separate workspace with its own lockfile
  cargoDeps = symlinkJoin {
    name = "${finalAttrs.pname}-${finalAttrs.version}-vendor";
    paths = [
      (rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-/vaaIdIHby1QGEAyTRJ2a8s06lXrq7YdJO9rNhH5mco=";
      })
      (rustPlatform.fetchCargoVendor {
        pname = "${finalAttrs.pname}-adapter";
        inherit (finalAttrs) version src;
        sourceRoot = "${finalAttrs.src.name}/wasm_abi/adapter";
        hash = "sha256-aUSdL/dGaWu/kCKdE+6VdzEE10bxRZhzINuPi13COS4=";
      })
    ];
  };

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [
    pkg-config
    rustc.llvmPackages.lld
  ];

  buildInputs = [
    zstd
    aws-lc
  ];

  cargoTestFlags = [
    "--package"
    "viceroy-lib"
  ];

  meta = {
    description = "Provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ereslibre
      stepbrobd
    ];
    platforms = lib.platforms.unix;
  };
})
