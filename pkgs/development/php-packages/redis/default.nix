{ buildPecl, lib, php }:

buildPecl {
  pname = "redis";

  version = "5.1.1";
  sha256 = "1041zv91fkda73w4c3pj6zdvwjgb3q7mxg6mwnq9gisl80mrs732";

  internalDeps = with php.extensions; [
    json
    session
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    hash
  ];

  meta.maintainers = lib.teams.php.members;
}
