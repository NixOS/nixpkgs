{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.0.4";
  sha256 = "1bvjmnx9bcfq4ikp02kiqg0f7ccgx4mkmz5d7g6v0d263x4r0wmj";

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta.maintainers = lib.teams.php.members;
}
