{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vimdoc-language-server";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "vimdoc-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1y9f3sn4LMkzMecaKXK4f6XvJPy3rE8jbF+w4N6p4gI=";
  };

  cargoHash = "sha256-hugC3b6nqmpvo9xfkEm7DzsIzeu6cqFFkSXWiuZeDnU=";

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
