{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "symbolicator";
  version = "25.5.1";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolicator";
    rev = version;
    hash = "sha256-4w7HC4m+aoIYPYQx2bgLcB/xfqXEX4XzYU4wR44OLRg=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vKIpVe5NDyk5RurUlUN8RdMMl1EAKa8rsCHXsFW6h8I=";

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
    SYMBOLICATOR_GIT_VERSION = src.rev;
    SYMBOLICATOR_RELEASE = version;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Native Symbolication as a Service";
    homepage = "https://getsentry.github.io/symbolicator/";
    changelog = "https://github.com/getsentry/symbolicator/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "symbolicator";
  };
}
