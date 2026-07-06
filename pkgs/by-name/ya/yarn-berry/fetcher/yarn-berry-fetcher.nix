{
  lib,
  rustPlatform,
  fetchFromGitLab,

  libzip,
  openssl,
  pkg-config,

  berryVersion,
  berryCacheVersion,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yarn-berry-${toString berryVersion}-fetcher";
  version = "1.3.1";

  src = fetchFromGitLab {
    domain = "cyberchaos.dev";
    owner = "yuka";
    repo = "yarn-berry-fetcher";
    tag = finalAttrs.version;
    hash = "sha256-4dT01SgTPwo9Vw7WIKtdRVP5+dd45YsTPOuf3V6SJg8=";
  };

  cargoHash = "sha256-l8zTzr2y8i2ENb8iadIBz59YLmNwfDZcrbUqIUibFqg=";

  env.YARN_ZIP_SUPPORTED_CACHE_VERSION = berryCacheVersion;
  env.LIBZIP_SYS_USE_PKG_CONFIG = 1;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    libzip
    openssl
  ];

  meta = {
    homepage = "https://cyberchaos.dev/yuka/yarn-berry-fetcher";
    license = lib.licenses.mit;
    mainProgram = "yarn-berry-fetcher";
    maintainers = with lib.maintainers; [
      flokli
    ];
  };
})
