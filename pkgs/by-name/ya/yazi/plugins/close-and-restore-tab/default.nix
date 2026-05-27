{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "close-and-restore-tab.yazi";
  version = "0-unstable-2026-05-23";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "close-and-restore-tab.yazi";
    rev = "d7638aadf1f6c4ca5ed2dbff2d3b07c6f86d9804";
    hash = "sha256-s9VOheYlUw7uqxZnd0+mN6lFghOi1shxf0DVIfn6unQ=";
  };

  meta = {
    description = "A Yazi plugin that adds the functionality to close and restore tab";
    homepage = "https://github.com/MasouShizuka/close-and-restore-tab.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
  };
}
