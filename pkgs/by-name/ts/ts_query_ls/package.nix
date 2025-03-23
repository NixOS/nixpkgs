{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:
let
  pname = "ts_query_ls";
  version = "1.9.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ribru17";
    repo = "ts_query_ls";
    rev = "v${version}";
    hash = "sha256-pjV5WRHcBZUFGr06YKlkZST0E47SNt5bxOM7my3TiF8=";
  };

  nativeBuildInputs = [ cmake ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-Tyw8IqaqHmxN//MNtrSuS0xLwh+xDjemquKouLIlsHQ=";

  meta = {
    description = "LSP implementation for Tree-sitter's query files";
    homepage = "https://github.com/ribru17/ts_query_ls";
    changelog = "https://github.com/ribru17/ts_query_ls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ribru17 ];
    mainProgram = "ts_query_ls";
  };
}
