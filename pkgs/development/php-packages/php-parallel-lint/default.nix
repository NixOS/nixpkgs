{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "php-parallel-lint";
  version = "1.3.2.999";

  src = fetchFromGitHub {
    owner = "php-parallel-lint";
    repo = "PHP-Parallel-Lint";
    rev = "539292fea03d718cc86e7137ad72ea35b694f2bf";
    hash = "sha256-VIBuS4PwRt20Ic5gYAXTv8p/5Nq/0B3VwMcp9zKbu5U=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-PHQ0N1eFCM4s/aPVpTsyZN5gnQpNe9Wfs6CG2RNxxbk=";

  meta = {
    description = "Tool to check syntax of PHP files faster than serial check with fancier output";
    homepage = "https://github.com/php-parallel-lint/PHP-Parallel-Lint";
    license = lib.licenses.bsd2;
    mainProgram = "parallel-lint";
    maintainers = lib.teams.php.members;
  };
})
