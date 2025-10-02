{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "25.5.31-unstable-2025-07-05";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "cbc4450a6c238114362e3c2fbca355166c2a2202";
    hash = "sha256-otD7zmm/Juh68D2czRhtU7CZFIaMgADxuo8p68cS7fk=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
