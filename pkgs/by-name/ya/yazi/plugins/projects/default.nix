{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "projects.yazi";
  version = "0-unstable-2025-06-19";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "projects.yazi";
    rev = "a5e33db284ab580de7b549e472bba13a5ba7c7b9";
    hash = "sha256-4VD1OlzGgyeB1jRgPpI4aWnOCHNZQ9vhh40cbU80Les=";
  };

  meta = {
    description = "Yazi plugin that adds the functionality to save and load projects";
    homepage = "https://github.com/MasouShizuka/projects.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
