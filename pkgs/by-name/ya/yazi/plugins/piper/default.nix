{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "25.9.15-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "398796d88fee7bf9c99c4dc29089b865d4f47722";
    hash = "sha256-LOQ/0LYVrXsqQjeBeERKQ2M8BwN8xo3yej1mxNHphOU=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
