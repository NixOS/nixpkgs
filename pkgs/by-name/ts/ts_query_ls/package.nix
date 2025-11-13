{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
let
  pname = "ts_query_ls";
  version = "3.12.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${version}";
    hash = "sha256-eb/3lY9qd+xWn1QEmDCxRY95ZWHSYxmOHq/mTFqiNiA=";
  };

  nativeBuildInputs = [ cmake ];

  cargoHash = "sha256-Y7OvSrFfQ71xufqNlJ5YNTKs00zzKCgCX+OOffTAkJw=";

  meta = {
    description = "LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
}
