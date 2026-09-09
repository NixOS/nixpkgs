{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "0-unstable-2026-08-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "6af9bf23be808db4a86e89d2fc32d488dcafdd34";
    hash = "sha256-LzIM/X2+/KLo/TO7XhFEBtgkzP7g5O98haOUb1wUCdU=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
