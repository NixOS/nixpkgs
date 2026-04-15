{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "symbolicator";
  version = "26.2.1";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolicator";
    rev = finalAttrs.version;
    hash = "sha256-CuG/rfwuJeKibsYWo1lNDcJkuKXMrXSv8hk+hIjYy74=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-YddQ3E6YlcFkoQEglTNJ1lK6ivxJYtwhouFT32kV1hI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ];

  env = {
    SYMBOLICATOR_GIT_VERSION = finalAttrs.src.rev;
    SYMBOLICATOR_RELEASE = finalAttrs.version;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require network access
  doCheck = false;

  meta = {
    description = "Native Symbolication as a Service";
    homepage = "https://getsentry.github.io/symbolicator/";
    changelog = "https://github.com/getsentry/symbolicator/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "symbolicator";
  };
})
