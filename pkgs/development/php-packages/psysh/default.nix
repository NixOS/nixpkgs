{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psysh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FoSqVnTEilKFqGxLZMMh2KNYWT8rLDUEmB4oekN7xIo=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-e/ltORFvIsYmY0xU6cti8tqUgb+y+l8hhTJNIMAAP8I=";

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
    mainProgram = "psysh";
    maintainers = lib.teams.php.members;
  };
})
