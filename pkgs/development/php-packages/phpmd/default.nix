{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpmd";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "phpmd";
    repo = "phpmd";
    rev = finalAttrs.version;
    hash = "sha256-nTuJGzOZnkqrfE9R9Vujz/zGJRLlj8+yRZmmnxWrieQ=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/phpmd/phpmd/issues/1056
  composerLock = ./composer.lock;
  vendorHash = "sha256-vr0wQkfhXHLEz8Q5nEq5Bocu1U1nDhXUlaHBsysvuRQ=";

  meta = {
    changelog = "https://github.com/phpmd/phpmd/releases/tag/${finalAttrs.version}";
    description = "PHP code quality analyzer";
    homepage = "https://phpmd.org/";
    license = lib.licenses.bsd3;
    mainProgram = "phpmd";
    maintainers = lib.teams.php.members;
  };
})
