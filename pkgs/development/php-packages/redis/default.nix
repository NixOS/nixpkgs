{ buildPecl, lib, php }:

buildPecl {
  pname = "redis";

  version = "5.3.4";
  sha256 = "1k5l7xxb06rlwq9jbmbbr03pc74d75vgv7h5bqjkbwan6dphafab";

  internalDeps = with php.extensions; [
    session
  ] ++ lib.optionals (lib.versionOlder php.version "8.0") [
    json
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    hash
  ];

  meta.maintainers = lib.teams.php.members;
}
