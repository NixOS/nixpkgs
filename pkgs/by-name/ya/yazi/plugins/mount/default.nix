{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "0-unstable-2026-10-23";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "e0bbd205de9759e7aa81857e1ff616eb5123e305";
    hash = "sha256-H/4Oi/D2M/aDEk/AourPURxfhoMxSm5UjaRgpeXrQ1Q=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
