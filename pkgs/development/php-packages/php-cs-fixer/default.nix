{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.51.0";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-49MzEEHFbr4jRYALdFqcQAOoQ3btoPkI9bpYJSxxnTo=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/issues/7590
  composerLock = ./composer.lock;
  vendorHash = "sha256-b0vrjv0dqQTD3nuo6nqpUtF4JkD8mj4OnNKKqp6hcvU=";

  meta = {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/v${finalAttrs.version}";
    description = "A tool to automatically fix PHP coding standards issues";
    homepage = "https://cs.symfony.com/";
    license = lib.licenses.mit;
    mainProgram = "php-cs-fixer";
    maintainers = lib.teams.php.members;
  };
})
