{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.21.1";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OWn5esJAX5dpVWCWNUAoS/sgZ7mxe2zbeAT1GIqY6zE=";
  };

  # TODO: Open a PR against https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-U23cleoLg/GXxd7PvwlenLTFJkeo1Yp6oc9UQxGUhOc=";

  meta = {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/${finalAttrs.version}";
    description = "A tool to automatically fix PHP coding standards issues";
    homepage = "https://cs.symfony.com/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
