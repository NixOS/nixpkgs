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
  vendorHash = "sha256-iQRY9DY2AEHuP3KJKC9ei8xcXgMvzxvyFl/9FwtN+kE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/v${finalAttrs.version}";
    description = "Tool to automatically fix PHP coding standards issues";
    homepage = "https://cs.symfony.com/";
    license = lib.licenses.mit;
    mainProgram = "php-cs-fixer";
    maintainers = [ lib.maintainers.patka ];
  };
})
