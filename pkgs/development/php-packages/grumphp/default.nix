{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YEapyEtvI0N9ey9UNbgRd15NyrCqRYJkmD+RuyysIRw=";
  };

  vendorHash = "sha256-0MH4Q5FY9nu5Jpz/iMIu99P8ptQY07t3qbXMp6J7bt4=";

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
