{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpmd";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "phpmd";
    repo = "phpmd";
    tag = finalAttrs.version;
    hash = "sha256-nTuJGzOZnkqrfE9R9Vujz/zGJRLlj8+yRZmmnxWrieQ=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/phpmd/phpmd/issues/1056
  composerLock = ./composer.lock;
  vendorHash = "sha256-AahAs3Gq1OQ+CW3+rU8NnWcR3hKzVNq7s3llsO4mQ38=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/phpmd/phpmd/releases/tag/${finalAttrs.version}";
    description = "PHP code quality analyzer";
    homepage = "https://phpmd.org/";
    license = lib.licenses.bsd3;
    mainProgram = "phpmd";
    teams = [ lib.teams.php ];
  };
})
