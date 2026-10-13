{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S1bD9tKQQf+71VoU6pTxS4IrScJ+D9hEwElWDJ1puRE=";
  };

  vendorHash = "sha256-Y2/m6HWK7IydmtPFocyidjtfe0BlF/lqhXko/lHeQ0g=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    teams = [ lib.teams.php ];
  };
})
