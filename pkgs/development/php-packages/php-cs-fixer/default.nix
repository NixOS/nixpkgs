{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.50.0";

  src = fetchFromGitHub {
    owner = "PHP-CS-Fixer";
    repo = "PHP-CS-Fixer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T0R/TfCLG9+Vcbsm5W8/7weI+e1RuSzTBc3VmRlG74c=";
  };

  # TODO: Open a PR against https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-kcEB7UZ++ZY5vhaoPGjaC3q1fpxYcZ/yZeMP3AdQBEk=";

  meta = {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/${finalAttrs.version}";
    description = "A tool to automatically fix PHP coding standards issues";
    homepage = "https://cs.symfony.com/";
    license = lib.licenses.mit;
    mainProgram = "php-cs-fixer";
    maintainers = lib.teams.php.members;
  };
})
