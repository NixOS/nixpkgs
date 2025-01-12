{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "x4";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "pwnwriter";
    repo = "x4";
    rev = "v${version}";
    hash = "sha256-IF+8lu56fzYM79p7MiNpVLFIs2GKPlzw5pNXD/hT6BM=";
  };

  cargoHash = "sha256-p3iMqnRW/quk2AHr2nLgOTvtshZ+xo6DGvWDsDj+bvU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Execute shell commands to server(s) via ssh protocol";
    homepage = "https://github.com/pwnwriter/x4";
    changelog = "https://github.com/pwnwriter/x4/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "x4";
  };
}
