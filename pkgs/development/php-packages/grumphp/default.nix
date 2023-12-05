{ fetchFromGitHub, stdenvNoCC, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "grumphp";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RVgreCspdz+A6mdE2H4i8ajmdH8AZ9BOIw2OqLw7HfI=";
  };

  patches = [
    ./composer-json.patch
  ];

  composerLock = stdenvNoCC.mkDerivation (finalComposerLockAttrs: {
    name = "grumphp-composer-lock";

    src = fetchFromGitHub {
      owner = "phpro";
      repo = "grumphp-shim";
      rev = "v${finalAttrs.version}";
      hash = "sha256-JxgRd0p/o3ouZ4MPke8cHqvAPuepY8ax0wx4t8+2dME=";
    };

    patches = [
      ./composer-lock.patch
    ];

    installPhase = ''
      runHook preInstall
      cp phar.composer.lock $out
      runHook postInstall
    '';
  });

  vendorHash = "sha256-yefamPAzIabDCzZ9ghKq9iPH7AoCdgCCQ8PKrUN9ifQ=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
