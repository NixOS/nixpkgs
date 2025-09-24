{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-48seCSiYvlNWPu9xP1kGKNwK+98F6wf602dxMjYLVio=";
  };

  vendorHash = "sha256-1sDvUuB5XsCqD23IDI4kVFZUiYhaqrwDg4xQgb2kC38=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    teams = [ lib.teams.php ];
  };
})
