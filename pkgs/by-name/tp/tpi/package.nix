{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "tpi";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "turing-machines";
    repo = "tpi";
    rev = "v${version}";
    hash = "sha256-rkqkb3iJL4obHjTkGEUbVPJmUmfT9KKP4yoQ71cbpKs=";
  };

  cargoHash = "sha256-hSWDr1XuD6x96QV2QIdhGPQ00Sg7G5O5bkFNTdUx0ug=";

  meta = {
    description = "CLI tool to control your Turing Pi 2 board";
    homepage = "https://github.com/turing-machines/tpi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ WoutSwinkels ];
    mainProgram = "tpi";
  };
}
