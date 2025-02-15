{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpstan";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    tag = finalAttrs.version;
    hash = "sha256-mhptuyX3tp0ABo8MEp+jL+P7jV6BiQhNPaxVlWggfjs=";
  };

  vendorHash = "sha256-WILu0qPmN4O6qiu9CF1R6Y2N8fNbdqWBbbS6lwdzo7k=";
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
