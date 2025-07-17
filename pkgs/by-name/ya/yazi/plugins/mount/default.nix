{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "25.5.28-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "c1d638374c76655896c06e9bc91cdb39857b7f15";
    hash = "sha256-cj2RjeW4/9ZRCd/H4PxrIQWW9kSOxtdi72f+8o13aPI=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
