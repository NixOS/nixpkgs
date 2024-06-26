{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "psysh";
  version = "0.11.21";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YuBn4mrgOzGeMGfGcyZySAISmQdv3WRGn91PRozyxdI=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-FZFeO7UiVssxTf0JX6wdjrAE+jucYnfQJA1eOng39lQ=";

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP";
    mainProgram = "psysh";
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = lib.teams.php.members;
  };
})
