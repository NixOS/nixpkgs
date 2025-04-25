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
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "cyberchaos.dev";
    owner = "yuka";
    repo = "yarn-berry-fetcher";
    tag = "1.0.1";
    hash = "sha256-v92+aeGmT151TvcW7FvuooF3g+opdZw7QHY+CcLweJE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TR9FT95WAaiRvoYBXeT0U6agF94BAdMswNncYysESKo=";

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
