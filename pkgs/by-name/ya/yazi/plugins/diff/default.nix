{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "diff.yazi";
  version = "25.2.7-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "398796d88fee7bf9c99c4dc29089b865d4f47722";
    hash = "sha256-LOQ/0LYVrXsqQjeBeERKQ2M8BwN8xo3yej1mxNHphOU=";
  };

  meta = {
    description = "Diff the selected file with the hovered file, create a living patch, and copy it to the clipboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
