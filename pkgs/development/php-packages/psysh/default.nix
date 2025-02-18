{
  fetchFromGitHub,
  fetchurl,
  lib,
  php,
}:

let
  pname = "psysh";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${version}";
    hash = "sha256-dgMUz7lB1XoJ08UvF9XMZGVXYcFK9sNnSb+pcwfeoqQ=";
  };

  composerLock = fetchurl {
    name = "composer.lock";
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/composer-v${version}.lock";
    hash = "sha256-JYJksHKyKKhU248hLPaNXFCh3X+5QiT8iNKzeGc1ZPw=";
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
      composer require --no-update symfony/polyfill-iconv:1.31 symfony/polyfill-mbstring:1.31
      composer require --no-update --dev roave/security-advisories:dev-latest
      composer update --lock --no-install
    '';

    vendorHash = "sha256-ODUfR7PsM1YKkEIl4KEAHcY2irqlqMGlpvmEYV1M2jk=";
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
