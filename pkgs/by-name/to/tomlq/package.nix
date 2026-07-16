{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tomlq";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "cryptaliagy";
    repo = "tomlq";
    tag = finalAttrs.version;
    hash = "sha256-obOR9q+fE5BnqZIsoL4zauKB+djEn1epqGwSjrI7QqU=";
  };

  cargoHash = "sha256-RkzAYVMycQwcewuP8wDbL06YddapyFhm+57CGOICey0=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
