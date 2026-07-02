{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "toggle-pane.yazi";
  version = "0-unstable-2026-05-07";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "4ffa48f33465c22cce48c5d506295a3eb27c1979";
    hash = "sha256-wr5QL493A175dRjYSyYpMMJax1RKWaZ3jAdFdL3XXTw=";
  };

  meta = {
    description = "Toggle the show, hide, and maximize states for different panes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
