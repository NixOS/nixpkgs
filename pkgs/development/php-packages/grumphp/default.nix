{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6SO5LUK39pEVcJqL86CwuyU7xpi8ydJxin5sHqBYwmg=";
  };

  vendorHash = "sha256-pupoPA4VZKACv4nPiRIwe1BOXojnnXrjKOpq0JGl9Uc=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    maintainers = lib.teams.php.members;
  };
})
