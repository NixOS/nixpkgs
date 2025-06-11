{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "projects.yazi";
  version = "0-unstable-2025-06-03";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "projects.yazi";
    rev = "7037dd5eee184ccb7725bdc9f7ea6faa188420d5";
    hash = "sha256-Lc0MeiAuPgJTq4ojNw9hwxqPJ74S4ymn4uPTkxGeZGc=";
  };

  meta = {
    description = "Yazi plugin that adds the functionality to save and load projects";
    homepage = "https://github.com/MasouShizuka/projects.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
