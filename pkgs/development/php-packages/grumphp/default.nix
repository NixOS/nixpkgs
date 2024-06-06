{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "grumphp";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-STTMqOzWE6c+EXA7PGoJTGVCyB3PtNVj5wSZ6igudro=";
  };

  vendorHash = "sha256-CrcDJb5SfTBxVkFPTLq0PSzqNtkZWDPkH0IW7Crr4Pw=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    maintainers = lib.teams.php.members;
  };
})
