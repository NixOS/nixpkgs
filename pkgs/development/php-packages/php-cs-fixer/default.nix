{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.86.0";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b68m8FVGf3qUbG1otRAQ8mnY0k3IBRBvigLYowgVH1g=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-JNtAMvuz9lFA+5c0O9XnI3Pid8TD1HaBqW2V2YDzkGw=";

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
