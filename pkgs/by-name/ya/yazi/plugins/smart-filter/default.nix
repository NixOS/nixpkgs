{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "smart-filter.yazi";
  version = "25.2.26-unstable-2025-03-02";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b44c245500b34e713732a9130bf436b13b4777e9";
    hash = "sha256-nZ8yfnKvNLM5aA+mmQ3PkfM5lwSKwWnkQewcg9GwseI=";
  };

  meta = {
    description = "Previewing archive contents with smart-filter";
    homepage = "https://yazi-rs.github.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
