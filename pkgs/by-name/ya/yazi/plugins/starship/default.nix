{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "starship.yazi";
  version = "25.4.8-unstable-2026-03-22";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "a83710153ab5625a64ef98d55e6ddad480a3756f";
    hash = "sha256-CPRVJVunBLwFLCoj+XfoIIwrrwHxqoElbskCXZgFraw=";
  };

  meta = {
    description = "Starship prompt plugin for yazi";
    homepage = "https://github.com/Rolv-Apneseth/starship.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
