{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "full-border.yazi";
  version = "0-unstable-2026-04-22";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "034efd687f689f1981ab0e5a7dd46c1e1b4a08c9";
    hash = "sha256-JIb26wE0WBf9Ul0wYW1/XpQICVTsNLgWgkXvtC457zo=";
  };

  meta = {
    description = "Add a full border to Yazi to make it look fancier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
