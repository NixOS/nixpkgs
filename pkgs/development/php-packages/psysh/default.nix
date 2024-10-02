{
  fetchFromGitHub,
  fetchurl,
  lib,
  php,
}:

let
  pname = "psysh";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    rev = "v${version}";
    hash = "sha256-Zvo0QWHkQhYD9OeT8cgTo2AW5tClzQfwdohSUd8pRBQ=";
  };

  composerLock = fetchurl {
    name = "composer.lock";
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/composer-v${version}.lock";
    hash = "sha256-ur6mzla3uXeFL6aEHAPdpxGdvcgzOgTLW/CKPbNqeCg=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  inherit
    pname
    version
    composerLock
    src
    ;

  composerVendor = php.mkComposerVendor {
    inherit
      src
      version
      pname
      composerLock
      ;

    preBuild = ''
      composer config platform.php 7.4
      composer require --no-update symfony/polyfill-iconv:1.29 symfony/polyfill-mbstring:1.29
      composer require --no-update --dev roave/security-advisories:dev-latest
      composer update --lock --no-install
    '';

    vendorHash = "sha256-mW276lzOTCY68EnvSVR+tD+gh3Y61GrWchVJHDZ4dpg=";
  };

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP";
    mainProgram = "psysh";
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = lib.teams.php.members;
  };
})
