{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpstan";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    rev = finalAttrs.version;
    hash = "sha256-CMIWxxryDDA38uyGl3SIooliU0ElAY1iAqnexn2Uq58=";
  };

  vendorHash = "sha256-CSkwBBV6b2inpQu4TKBR23Du11mzr3rV6GtprzHAOgQ=";
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
