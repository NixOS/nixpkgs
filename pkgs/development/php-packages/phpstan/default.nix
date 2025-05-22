{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpstan";
  version = "2.1.15";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    tag = finalAttrs.version;
    hash = "sha256-1MHEN7/OL35xBLkwW7j2CxkjGb4EUkV1Zc8Nvn4xqNI=";
  };

  vendorHash = "sha256-7PAO+8hkeNQH9lM77NvRX2/56PlIgWCwJ700b4erM2Y=";
  composerStrictValidation = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phpstan/phpstan/releases/tag/${finalAttrs.version}";
    description = "PHP Static Analysis Tool";
    homepage = "https://github.com/phpstan/phpstan";
    longDescription = ''
      PHPStan focuses on finding errors in your code without actually
      running it. It catches whole classes of bugs even before you write
      tests for the code. It moves PHP closer to compiled languages in the
      sense that the correctness of each line of the code can be checked
      before you run the actual line.
    '';
    license = lib.licenses.mit;
    mainProgram = "phpstan";
    teams = [ lib.teams.php ];
  };
})
