{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "25.5.31-unstable-2025-07-02";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "e5f00e2716fd177b0ca0d313f1a6e64f01c12760";
    hash = "sha256-DLcmzCmITybWrYuBpTyswtoGUimpagkyeVUWmbKjarY=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
