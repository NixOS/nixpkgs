{ fetchFromGitHub, fetchurl, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psysh";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v2UAhxnfnVwA05sxcqMU5vmQcwlBcc901PYJqYf+pCw=";
  };

  composerLock = fetchurl {
    name = "composer.lock";
    url = "https://github.com/bobthecow/psysh/releases/download/v${finalAttrs.version}/composer-v${finalAttrs.version}.lock";
    hash = "sha256-ur6mzla3uXeFL6aEHAPdpxGdvcgzOgTLW/CKPbNqeCg=";
  };

  composerRepository = {
    preBuild = ''
      setComposeRootVersion
      composer config platform.php 7.4
      composer require --no-update symfony/polyfill-iconv symfony/polyfill-mbstring
      composer require --no-update --dev roave/security-advisories:dev-latest
      composer update --no-interaction --no-progress --prefer-stable --no-dev --classmap-authoritative --prefer-dist --lock
    '';
  };

  vendorHash = "sha256-vlEbehxy6xi2qLKG32fV0OJVSphWjqKUVHbWOhoWjoI=";

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    mainProgram = "psysh";
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = lib.teams.php.members;
  };
})
