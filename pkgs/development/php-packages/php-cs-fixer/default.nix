{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "php-cs-fixer";
  version = "3.16.0";

  src = fetchFromGitHub {
    owner = "FriendsOfPHP";
    repo = "PHP-CS-Fixer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d8oypyaR8B7DHP92UtnRLuUv4SRKAOJ8cGDLxw3IlwM=";
  };

  # TODO: Open a PR against https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-pNnREHUMgj50yrVudYqWCDoflzFnGRjStTuCtVsjVPI=";

  meta = with lib; {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/${finalAttrs.version}";
    description = "A tool to automatically fix PHP coding standards issues";
    license = licenses.mit;
    homepage = "https://cs.symfony.com/";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
})
