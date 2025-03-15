{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tomlq";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "cryptaliagy";
    repo = "tomlq";
    tag = finalAttrs.version;
    hash = "sha256-g8xjz8qCTiulTwcEbLTHYldw4PI+4ZfCOMJs+J6L1C4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/n1+8n0zGs9qS5QQcAfXJ1kmRkcfsCTxQonEaFsNdHo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for getting data from TOML files on the command line";
    homepage = "https://github.com/cryptaliagy/tomlq";
    changelog = "https://github.com/cryptaliagy/tomlq/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kinzoku ];
    mainProgram = "tq";
  };
})
