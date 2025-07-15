{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "toggle-pane.yazi";
  version = "25.5.28-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "a54b96a3f21495ab3659e45d5354bcc8413be15c";
    hash = "sha256-TtVaWazkk2xnomhJFinElbUsXUKAbDDhLEVq5Ah3nAk=";
  };

  meta = {
    description = "Toggle the show, hide, and maximize states for different panes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
