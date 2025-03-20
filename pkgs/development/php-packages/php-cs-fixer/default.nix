{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.70.1";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FIqEVChYxtFqD9RcOttSk1QTPzG3HUBZmFI0wWY2BTQ=";
  };

  # Upstream doesn't provide a composer.lock.
  # More info at https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/issues/7590
  composerLock = ./composer.lock;
  vendorHash = "sha256-4MrmdAiBruOF68KVrsnDPTKe9hrHvUmzfvyrG6rt7L0=";

  meta = {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/v${finalAttrs.version}";
    description = "Tool to automatically fix PHP coding standards issues";
    homepage = "https://cs.symfony.com/";
    license = lib.licenses.mit;
    mainProgram = "php-cs-fixer";
    maintainers = lib.teams.php.members;
  };
})
