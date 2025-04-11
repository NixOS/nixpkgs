{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "miller.yazi";
  version = "0-unstable-2024-08-28";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "miller.yazi";
    rev = "40e02654725a9902b689114537626207cbf23436";
    hash = "sha256-GXZZ/vI52rSw573hoMmspnuzFoBXDLcA0fqjF76CdnY=";
  };

  meta = {
    description = "Miller, now in yazi.";
    homepage = "https://github.com/Reledia/miller.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
