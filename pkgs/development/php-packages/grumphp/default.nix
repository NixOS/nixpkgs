{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W4LNzdgWxXDPL46/C8SX99lpRMp/xL5q5v6vX3H80XU=";
  };

  vendorHash = "sha256-9oInSBlN6hDe9Bj/ISP/7O9Q1xp4tXRm99XhsrJog0E=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    maintainers = lib.teams.php.members;
  };
})
