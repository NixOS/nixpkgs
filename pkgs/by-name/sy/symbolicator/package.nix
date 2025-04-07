{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  zstd,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "symbolicator";
  version = "25.3.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolicator";
    tag = version;
    hash = "sha256-/8Jo/M51ulrQFzXKkcFXTYfh9a3w6C5oW6A/bDFcRp0=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mWvCvzqTUzpxYYxf8KWjxfo4E7oS9oNVbeVxx8J3QwI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      bzip2
      openssl
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
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
