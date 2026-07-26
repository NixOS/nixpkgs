{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "diff.yazi";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "bbac5e75b22a2893ef7cdd2bd6814b15f2abb91e";
    hash = "sha256-lio4pvrqK575q7M+GtRr/5EdA4h2J/7gIvXK8c5rq1U=";
  };

  meta = {
    description = "Diff the selected file with the hovered file, create a living patch, and copy it to the clipboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
