{ buildPecl, lib, php }:

buildPecl {
  pname = "redis";

  version = "5.3.2";
  sha256 = "1cfsbxf3q3im0cmalgk76jpz581zr92z03c1viy93jxb53k2vsgl";

  internalDeps = with php.extensions; [
    json
    session
  ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
    hash
  ];

  meta.maintainers = lib.teams.php.members;
}
