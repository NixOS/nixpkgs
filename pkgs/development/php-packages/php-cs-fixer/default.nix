{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.94.2";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eX9awtJeOJSX0Q+687egTTRZFpj5qTjjAamGpJUMKzA=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-b3K7Ed/gtqyyEDrivMX8SFXe0X2XeJJ+zM6Pp1jY+Ow=";

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
