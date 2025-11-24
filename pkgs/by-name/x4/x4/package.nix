{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
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

  cargoHash = "sha256-iWLRXi7Xt4FQPgXGhk6+mDi1T+Jxrvh7S4myL0cYXec=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
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
