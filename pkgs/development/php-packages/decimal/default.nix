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
  hash = "sha256-it8w8hOLYwtCZoDYhaP5k5TD/pQLtj37K2lSESF80ok=";

  # The source is a PECL tarball and PECL lacks releases that GitHub tags have (2.0.2)
  passthru.updateScript = null;

  buildInputs = [ mpdecimal ];
  configureFlags = [ "--with-libmpdec-path=${mpdecimal}" ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    description = "Arbitrary-precision decimal arithmetic for PHP";
    homepage = "https://php-decimal.github.io";
    changelog = "https://pecl.php.net/package-changelog.php?package=decimal&release=${version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.php ];
  };
}
