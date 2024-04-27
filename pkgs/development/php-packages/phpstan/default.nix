{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpstan";
  version = "1.10.66";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    rev = finalAttrs.version;
    hash = "sha256-ZEQ6oP6zyi0cL69J9ck8gAht5taPkzH+iW5ALC4saAQ=";
  };

  vendorHash = "sha256-Qp/eMhcKK32N1EMgeIspBDs28Oofwn6n2bEFKqvSx9E=";
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
