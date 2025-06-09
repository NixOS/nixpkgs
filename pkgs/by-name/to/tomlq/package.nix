{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tomlq";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "cryptaliagy";
    repo = "tomlq";
    tag = version;
    hash = "sha256-g8xjz8qCTiulTwcEbLTHYldw4PI+4ZfCOMJs+J6L1C4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/n1+8n0zGs9qS5QQcAfXJ1kmRkcfsCTxQonEaFsNdHo=";

  meta = {
    description = "Tool for getting data from TOML files on the command line";
    homepage = "https://github.com/cryptaliagy/tomlq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kinzoku ];
    mainProgram = "tq";
  };
}
