{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vimdoc-language-server";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "vimdoc-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Uy9RUauRf9IjfykjrLRviKaMNX2fpmSdA/bvkYqgQY=";
  };

  cargoHash = "sha256-319K2fD8ae+MWgvNhmhgrD6syCDkO2FMgXr8z45CMr4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for vim help files";
    homepage = "https://github.com/barrettruth/vimdoc-language-server";
    changelog = "https://github.com/barrettruth/vimdoc-language-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ barrettruth ];
    mainProgram = "vimdoc-language-server";
  };
})
