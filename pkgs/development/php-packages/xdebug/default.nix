{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.0.0";
  sha256 = "0qnaqgn2rdjxc70lyrm3nmy7cfma69c7zn6if23hhkhx5kl0fl44";

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta.maintainers = lib.teams.php.members;
}
