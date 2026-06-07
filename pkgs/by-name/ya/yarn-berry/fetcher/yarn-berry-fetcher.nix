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
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "cyberchaos.dev";
    owner = "yuka";
    repo = "yarn-berry-fetcher";
    tag = finalAttrs.version;
    hash = "sha256-7WW/fHTi1i7dcsSJDl4kb1E6hUY6flRaVdbjD93OKPk=";
  };

  cargoHash = "sha256-l8zTzr2y8i2ENb8iadIBz59YLmNwfDZcrbUqIUibFqg=";

  env.YARN_ZIP_SUPPORTED_CACHE_VERSION = berryCacheVersion;
  env.LIBZIP_SYS_USE_PKG_CONFIG = 1;

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
      yuka
      flokli
    ];
  };
})
