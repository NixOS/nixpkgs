{
  buildPecl,
  lib,
  mpdecimal,
  php,
}:
let
  version = "1.5.0";
in
buildPecl {
  pname = "decimal";

  version = version;
  sha256 = "it8w8hOLYwtCZoDYhaP5k5TD/pQLtj37K2lSESF80ok=";

  internalDeps = lib.optional (lib.versionOlder php.version "8.0") php.extensions.json;
  buildInputs = [ mpdecimal ];
  configureFlags = [ "--with-libmpdec-path=${mpdecimal}" ];

  meta = {
    description = "Arbitrary-precision decimal arithmetic for PHP";
    homepage = "https://php-decimal.github.io";
    changelog = "https://pecl.php.net/package-changelog.php?package=decimal&release=${version}";
    license = lib.licenses.mit;
    broken = lib.versionOlder php.version "7.0";
    maintainers = lib.teams.php.members;
  };
}
