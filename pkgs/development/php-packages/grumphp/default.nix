{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "grumphp";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h4vdLdL7gnaHbAIebMPxAg80XwWu+Mxbh4rgBoc52eY=";
  };

  # TODO: Open a PR against https://github.com/phpro/grumphp
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-VQ+H54yrpR/giJkpW00ZaR5wzaTG2dJnCzSIi0pA3+0=";

  meta = with lib; {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = licenses.mit;
    maintainers = teams.php.members;
  };
})
