{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "no-status.yazi";
  version = "25.2.7-unstable-2025-03-02";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b44c245500b34e713732a9130bf436b13b4777e9";
    hash = "sha256-nZ8yfnKvNLM5aA+mmQ3PkfM5lwSKwWnkQewcg9GwseI=";
  };

  meta = {
    description = "Remove the status bar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
