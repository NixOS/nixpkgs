{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psysh";
  version = "0.11.18";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TG/ADbeb1whkAwX46aFDRPPNZ65MIB4Mel185APiQ+0=";
  };

  # TODO: Open a PR against https://github.com/bobthecow/psysh
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;

  vendorHash = "sha256-Mw2MYz+6weljwL8i8vaqVMwzc4J6ZwfygxVi0gCjNXM=";

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    homepage = "https://psysh.org/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
