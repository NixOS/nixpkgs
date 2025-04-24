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
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "cyberchaos.dev";
    owner = "yuka";
    repo = "yarn-berry-fetcher";
    tag = "1.0.0";
    hash = "sha256-iMU/SadzrNv8pZSgp2fBwWVgrgZsnyPRsvs0ugvwyks=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ETFaCu+6Ar7tEeRCbTbesEqx9BdztSvPXB7Dc5KGIx0=";

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
