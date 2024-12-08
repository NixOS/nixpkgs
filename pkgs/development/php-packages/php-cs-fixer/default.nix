{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.64.0";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-N2m3U0HjwQtm7loqYfEl7kstqljXC8evp6GEh+Cd9Hs=";
  };

  # Upstream doesn't provide a composer.lock.
  # More info at https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/issues/7590
  composerLock = ./composer.lock;
  vendorHash = "sha256-cOKfvNjFl9QKwPZp81IHaRurRhmXgbydhdTWYknlGBM=";

  meta = {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/v${finalAttrs.version}";
    description = "Tool to automatically fix PHP coding standards issues";
    homepage = "https://cs.symfony.com/";
    license = lib.licenses.mit;
    mainProgram = "php-cs-fixer";
    maintainers = lib.teams.php.members;
  };
})
