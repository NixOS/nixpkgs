{ buildPecl, lib }:

buildPecl {
  pname = "xdebug";

  version = "3.0.3";
  sha256 = "sha256-5yZagVGOOX+XLcki50bRpIRTcXf/SJVDUWfRCeKTJDI=";

  doCheck = true;
  checkTarget = "test";

  zendExtension = true;

  meta.maintainers = lib.teams.php.members;
}
