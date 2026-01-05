{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "25.9.15-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "109b13df29f4b7d14fd8e1b38414b205e706c761";
    hash = "sha256-u8gbZnA8xShsbH06yCZM/aXskMrSHKPcQtIMFp1Cdyo=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
