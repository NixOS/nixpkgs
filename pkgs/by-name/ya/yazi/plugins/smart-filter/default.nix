{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "smart-filter.yazi";
  version = "25.5.31-unstable-2025-07-23";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "de53d90cb2740f84ae595f93d0c4c23f8618a9e4";
    hash = "sha256-ixZKOtLOwLHLeSoEkk07TB3N57DXoVEyImR3qzGUzxQ=";
  };

  meta = {
    description = "Yazi plugin that makes filters smarter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
