{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "treemd";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "Epistates";
    repo = "treemd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QZz/C1YSqzN+IMkru/MaZpcS5YqkN4PozxSthDg6YPI=";
  };

  cargoHash = "sha256-PnBOWTHwRMkhDzTGnmytAVVMNHqFZghF1F7bFlkyrGo=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI/CLI markdown navigator with tree-based structural navigation";
    homepage = "https://github.com/Epistates/treemd";
    changelog = "https://github.com/Epistates/treemd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "treemd";
  };
})
