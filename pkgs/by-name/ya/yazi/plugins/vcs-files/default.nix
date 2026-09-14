{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "0-unstable-2026-09-09";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "58c4f4e2f4835cc9bf6751f39e3f7c574fc7f55a";
    hash = "sha256-kwf9+KXOL5JXGDoEGdtwq+JujP8GVoOwDgz76FBM3xk=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
