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
  version = "1.2.2";

  src = fetchFromGitLab {
    domain = "cyberchaos.dev";
    owner = "yuka";
    repo = "yarn-berry-fetcher";
    tag = finalAttrs.version;
    hash = "sha256-4lPnjLvS9MBtFyIqFKY91w/6MAesziGMJLrE60djEsI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-i0AJ3z+7oSqBW45Vs6dojcipQPoaIa6bejhqCfkdZNA=";

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
