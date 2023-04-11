{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpmd";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "phpmd";
    repo = "phpmd";
    rev = finalAttrs.version;
    hash = "sha256-4ZBtoAJC8nnfwZavIVDt33+yKQ1ZNLBym/UT11ciax8=";
  };

  # TODO: Open a PR against https://github.com/phpmd/phpmd
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-Y/3zSRUsuRUyV53wQI+vavudx2jVUV8rZv4CThX8DJE=";

  meta = {
    changelog = "https://github.com/phpmd/phpmd/releases/tag/${finalAttrs.version}";
    description = "PHP code quality analyzer";
    license = lib.licenses.bsd3;
    homepage = "https://phpmd.org/";
    maintainers = lib.teams.php.members;
  };
})
