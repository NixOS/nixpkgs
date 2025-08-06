{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
let
  pname = "ts_query_ls";
  version = "3.10.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${version}";
    hash = "sha256-D8coYFkPOCt7eGeb/Qo4GLqtJNF7kn3gOjF3nUT4+H4=";
  };

  nativeBuildInputs = [ cmake ];

  cargoHash = "sha256-/HcvW0TIDrzgLUVt7yqy4cZ537rNVWP/qUBphWwyde8=";

  meta = {
    description = "LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
}
