{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "7749958b00d461d3c0fba4aa651940d778d1fc3f";
    hash = "sha256-DZNhqIuGZIEEEH1TrCtAjZKa+7CWZeS1wO9aA9C0Eec=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
