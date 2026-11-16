{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "25d992d7de29a6fbaeff8d3b27007a33225cd118";
    hash = "sha256-ihkKeOQ7HG/oS1DSYLDOifmhzY9nqEu6xC+DtrpzR3w=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
