{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "toggle-pane.yazi";
  version = "0-unstable-2026-06-26";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "39aaf6dc77e546fe7f7836f102a6c57f96d15365";
    hash = "sha256-rl8EA8aymVQU1296IVsEZ2WR9xBxQTYBK+VUCic/K3k=";
  };

  meta = {
    description = "Toggle the show, hide, and maximize states for different panes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
