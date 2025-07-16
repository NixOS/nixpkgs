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
  version = "25.6.2";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolicator";
    rev = version;
    hash = "sha256-So6WApFwgTlhwcQlxBUVlL/JPW1X+ZkJhFxb+0ZMI3o=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eQJ/V+4uvcg8v+b8DVJHGNbOq9OTCs/E6wU0WBuxsEA=";

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
