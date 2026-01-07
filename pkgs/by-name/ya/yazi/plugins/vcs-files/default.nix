{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "25.12.29-unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "4e5590280db0de5f130bf377e9c32a202110f575";
    hash = "sha256-/yGS8R1YsYqqX4JTlIJeg+NfFSxGUHvSdKQZGk6KiBU=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
