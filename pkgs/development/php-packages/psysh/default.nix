{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psysh";
  version = "0.11.17";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8MUNiLUyn3zBNQ2PJo08t3w1SorSquuYzdpdHg3wp+Y=";
  };

  # TODO: Open a PR against https://github.com/bobthecow/psysh
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;

  vendorHash = "sha256-4SILP475ICY6sMUobvbbRJH5WZTZyFxB42nZb42UhEQ=";

  meta = with lib; {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    license = licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = teams.php.members;
  };
})
