{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "16e8ed382db5fc5ea9d179a2803d86859803fae0";
    hash = "sha256-ALSuXdAGGcscQmGL2d6cDv6MzNiuzl52f9i1b3t+b1I=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
