{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
let
  pname = "ts_query_ls";
  version = "1.0.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${version}";
    hash = "sha256-rmP1jCT1cs+kq9axgVNM0nHPYMQ0ihJuh9izd2tBbzc=";
  };

  nativeBuildInputs = [ cmake ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-query-0.4.0" = "sha256-snr0ze1VCaAf448mHkrB9qbWTMvjSlPdVl2VtesMIHI=";
    };
  };

  meta = {
    description = "An LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
}
