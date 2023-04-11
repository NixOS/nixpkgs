{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "php-parallel-lint";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "php-parallel-lint";
    repo = "PHP-Parallel-Lint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pTHH19HwqyOj5pSmH7l0JlntNVtMdu4K9Cl+qyrrg9U=";
  };

  # TODO: Open a PR against https://github.com/php-parallel-lint/PHP-Parallel-Lint
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-X5hBkdwtNDiRxxbjBUO3m2Xg4LTegot5UuSy4IpajP8=";

  meta = with lib; {
    description = "Tool to check syntax of PHP files faster than serial check with fancier output";
    license = licenses.bsd2;
    homepage = "https://github.com/php-parallel-lint/PHP-Parallel-Lint";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
})
