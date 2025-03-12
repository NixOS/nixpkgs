{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpstan";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    tag = finalAttrs.version;
    hash = "sha256-skJx4kFbVtHaCOhOWM2dds1ext7wuy6YvMaYAI9IxJM=";
  };

  vendorHash = "sha256-51CB2i4oD4BtXRqzB8U+H/9CwWTKFP2mM2hcUlqRuPw=";
  composerStrictValidation = false;

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
    maintainers = lib.teams.php.members;
  };
})
