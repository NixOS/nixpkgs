{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "projects.yazi";
  version = "0-unstable-2025-05-29";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "projects.yazi";
    rev = "96af237d2255d5dab5493c020f55561f63c28777";
    hash = "sha256-N8XH6adXPk/iU173fXEViv0NPwFZ0WYiyEJGBs4c6ec=";
  };

  meta = {
    description = "Yazi plugin that adds the functionality to save and load projects";
    homepage = "https://github.com/MasouShizuka/projects.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
