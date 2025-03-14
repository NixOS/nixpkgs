{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JRLx9laFdtHSwyUmnAQY4Rcaac6buhbA2vfBCIAzk04=";
  };

  vendorHash = "sha256-ptRWX0W0UylsaDjpjdaYq+KBx9aAxYzKGeI44lby+OY=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    maintainers = lib.teams.php.members;
  };
})
