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
  version = "26.1.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolicator";
    rev = finalAttrs.version;
    hash = "sha256-sqfp48lDpFwxgKL4CduBVbsYxxpaAugaybp7JKFLuX8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-7L75EFVU+5YygOuv/7KlD4JXfBKOW9vTumE0aNmLRyU=";

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
