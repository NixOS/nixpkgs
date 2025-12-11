{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.87.2";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IPBMi8Bln99zcCxkNPGKWSUQMvtxHlRq4BwuoMCXkYw=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-I4F6WDnWDEmLJFRGMS2QV62jaNAtZoTNQBoH3gT3OAw=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    broken = lib.versionOlder php.version "8.2";
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/v${finalAttrs.version}";
    description = "Tool to automatically fix PHP coding standards issues";
    homepage = "https://cs.symfony.com/";
    license = lib.licenses.mit;
    mainProgram = "php-cs-fixer";
    maintainers = [ lib.maintainers.patka ];
  };
})
