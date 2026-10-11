{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "word-snatchers-cli";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "akgondber";
    repo = "word-snatchers-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T3xBVes4ykE/UiAEXCytwrgopxyFxvvowMaTbglUM6w=";
  };

  npmDepsHash = "sha256-TLz4NePVMRJ8BdCFg+pnMVbiXOXIr7mz0q1L9GTbXGM=";

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Game of unscramble the letters to spell out a word fitting the given definition";
    homepage = "https://github.com/akgondber/word-snatchers-cli";
    changelog = "https://github.com/akgondber/word-snatchers-cli/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "word-snatchers-cli";
  };
})
