{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "diff.yazi";
  version = "0-unstable-2026-07-01";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "65559fd3edc33cb0fd24ec92874c763fa5f68e3e";
    hash = "sha256-SLfwFGOcmlZIUqlSSMk7dEEUZQbKqPMidknS3vtFzPo=";
  };

  meta = {
    description = "Diff the selected file with the hovered file, create a living patch, and copy it to the clipboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
