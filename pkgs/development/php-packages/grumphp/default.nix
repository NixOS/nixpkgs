{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mAdOd7nSXbyrqymPeMcl9kyUmaxUbGkKUe2rRHEiflI=";
  };

  vendorHash = "sha256-MF/tdsKoc0o2ckQB4esrCjRyBg7lBUSa5KJ2+RmjdO0=";

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
