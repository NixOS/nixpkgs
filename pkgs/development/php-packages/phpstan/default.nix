{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpstan";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-jTyKR1sgRdGTEIhQWlAH1/0gbq5dObxXmLiEcp7+I7c=";
  };

  vendorHash = "sha256-U4J/uHZjCH8S33RdnStzfWW3RrbOPpX5jMC6FTkBYHE=";
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
