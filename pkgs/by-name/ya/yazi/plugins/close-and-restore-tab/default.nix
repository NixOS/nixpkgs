{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "close-and-restore-tab.yazi";
  version = "0-unstable-2026-04-22";

  src = fetchFromGitHub {
    owner = "MasouShizuka";
    repo = "close-and-restore-tab.yazi";
    rev = "5047217e59f9c2f4aa5ae15baa92df7b3f724e67";
    hash = "sha256-bsx6HVdB2CcKXQG+tGxY2T8Ys8TluIe6xWHhOhv4L4I=";
  };

  meta = {
    description = "A Yazi plugin that adds the functionality to close and restore tab";
    homepage = "https://github.com/MasouShizuka/close-and-restore-tab.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
  };
}
