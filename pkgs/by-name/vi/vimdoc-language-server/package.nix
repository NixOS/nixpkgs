{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vimdoc-language-server";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "vimdoc-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iLNRJlQbhaz9zm+XWlck1bzkMj/tP7uN2PixNy+wZpo=";
  };

  cargoHash = "sha256-g0YlVcWOdQvgEKZvfusNn0ZVZYOgKeHp0G8OQ96BDn0=";

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
