{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "2.8.1";
  sha256 = "080mwr7m72rf0jsig5074dgq2n86hhs7rdbfg6yvnm959sby72w3";

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta.maintainers = lib.teams.php.members;
}
