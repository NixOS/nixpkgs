{ buildPecl, lib, php }:

buildPecl {
  pname = "redis";

  version = "5.3.3";
  sha256 = "sha256-N3iRYeFkzVIjmjDJojjaYf7FyDlc2sOFtu2PDFD9kvA=";

  internalDeps = with php.extensions; [
    session
  ] ++ lib.optionals (lib.versionOlder php.version "8.0") [
    json
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    hash
  ];

  meta.maintainers = lib.teams.php.members;
}
