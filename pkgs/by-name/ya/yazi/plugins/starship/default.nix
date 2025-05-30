{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "starship.yazi";
  version = "25.4.8-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "428d43ac0846cb1885493a1f01c049a883b70155";
    hash = "sha256-YkDkMC2SJIfpKrt93W/v5R3wOrYcat7QTbPrWqIKXG8=";
  };

  meta = {
    description = "Starship prompt plugin for yazi";
    homepage = "https://github.com/Rolv-Apneseth/starship.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
