{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "lazygit.yazi";
  version = "0-unstable-2025-03-31";

  src = fetchFromGitHub {
    owner = "Lil-Dank";
    repo = "lazygit.yazi";
    rev = "7a08a0988c2b7481d3f267f3bdc58080e6047e7d";
    hash = "sha256-OJJPgpSaUHYz8a9opVLCds+VZsK1B6T+pSRJyVgYNy8=";
  };

  meta = {
    description = "Lazygit plugin for yazi";
    homepage = "https://github.com/Lil-Dank/lazygit.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
