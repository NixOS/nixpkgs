{ buildPecl, lib }:

buildPecl {
  pname = "ast";

  version = "1.0.12";
  sha256 = "1mcfx989yrakixlsx2d8v6kyxawfwhig4mra9ccpjasfhad0d31x";

  meta.maintainers = lib.teams.php.members;
}
