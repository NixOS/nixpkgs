{ buildPecl, lib }:

buildPecl {
  pname = "ast";

  version = "1.0.10";
  sha256 = "13s5r1szd80g1mqickghdd38mvjkwss221322mmbrykcfgp4fs30";

  meta.maintainers = lib.teams.php.members;
}
