{ buildPecl, lib }:

buildPecl {
  pname = "ast";

  version = "1.0.5";
  sha256 = "16c5isldm4csjbcvz1qk2mmrhgvh24sxsp6w6f5a37xpa3vciawp";

  meta.maintainers = lib.teams.php.members;
}
