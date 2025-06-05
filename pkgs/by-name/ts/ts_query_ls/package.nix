{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
let
  pname = "ts_query_ls";
  version = "3.2.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${version}";
    hash = "sha256-sr9uSjSbX/Af/g8OSrSMQXCpObxTblZw7qe5OTfqXvA=";
  };

  nativeBuildInputs = [ cmake ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-y9AR9qWJXRHcf8vtOvBZxMCUZvC/ty/4jF5mkhdMy9Y=";

  meta = {
    description = "LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
}
