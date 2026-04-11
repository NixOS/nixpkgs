{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "projects.yazi";
  version = "0-unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "projects.yazi";
    rev = "198c2ba30e4916ca275d2a08bd329fcf32735866";
    hash = "sha256-Grvtx+N1DpdpMaVuDwaHu3S7zu6pQtmu1twvFIowbLM=";
  };

  meta = {
    description = "Yazi plugin that adds the functionality to save and load projects";
    homepage = "https://github.com/MasouShizuka/projects.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
