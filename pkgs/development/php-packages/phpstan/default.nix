{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpstan";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-hKNwAZCK7dS/iBTrigEHSBXnCJQ2btSUDMUrfetiL0s=";
  };

  vendorHash = "sha256-m5Ih/3a3p5BgifpK+vu2Z04glIc0vhz1/ikA4Hl0L7U=";
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
