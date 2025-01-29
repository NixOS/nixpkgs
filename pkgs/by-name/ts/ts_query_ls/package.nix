{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
let
  pname = "ts_query_ls";
  version = "1.0.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${version}";
    hash = "sha256-jhlFFNzGP9SNw4G2arGPQzQ7KQ4duCse/CQoK9lWaPk=";
  };

  nativeBuildInputs = [ cmake ];
  doCheck = false; # no tests

  useFetchCargoVendor = true;
  cargoHash = "sha256-CgX8lPOX3ZvoSD4SuKR8MTpKvLrhIbzrXqlKrvY0xzE=";

  meta = {
    description = "LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
}
