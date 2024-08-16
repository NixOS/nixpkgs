{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpstan";
  version = "1.11.8";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    rev = finalAttrs.version;
    hash = "sha256-wF2OqJ0kg+wEjSq8mAyF5em5RAqjyXqKFkdAjxOrePM=";
  };

  vendorHash = "sha256-8WJg3zfPk0tFU5GZvjnqG8iS4p9oOoBWDX0jYhQ1AXw=";
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
