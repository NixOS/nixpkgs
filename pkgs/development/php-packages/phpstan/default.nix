{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpstan";
  version = "1.10.65";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    rev = finalAttrs.version;
    hash = "sha256-mKNix5TEnr0aUHxn9cYvFafU7yLhTe8AVkHZcu0/a1M=";
  };

  vendorHash = "sha256-NezEoraSomeeMbY7qz2pH2EwLr/VXO1tmWJ5/2fS/qU=";
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
