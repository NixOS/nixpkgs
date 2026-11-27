{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpmd";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "phpmd";
    repo = "phpmd";
    tag = finalAttrs.version;
    hash = "sha256-9x1Hza7ylkdyuyZoUwqEgaVlL84gbVyzpAVPgOj69GM=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/phpmd/phpmd/issues/1056
  composerLock = ./composer.lock;
  vendorHash = "sha256-YC2yLpweN89BWK9trFYXOOZRealOFz6XIluKtIbmAHU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/phpmd/phpmd/releases/tag/${finalAttrs.version}";
    description = "PHP code quality analyzer";
    homepage = "https://phpmd.org/";
    license = lib.licenses.bsd3;
    mainProgram = "phpmd";
    teams = [ lib.teams.php ];
  };
})
