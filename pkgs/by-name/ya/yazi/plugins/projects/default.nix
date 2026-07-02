{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "projects.yazi";
  version = "0-unstable-2026-05-30";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "projects.yazi";
    rev = "112a2707e9d37c02304449fbc8669d0264841e22";
    hash = "sha256-w7QTVogc7pqVa56fSCl22m8AkOHO5jq+yXLfCRaY1Yg=";
  };

  meta = {
    description = "Yazi plugin that adds the functionality to save and load projects";
    homepage = "https://github.com/MasouShizuka/projects.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
