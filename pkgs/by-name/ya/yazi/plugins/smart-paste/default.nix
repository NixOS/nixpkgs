{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "smart-paste.yazi";
  version = "25.5.28-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "d642bfb0822eb0c3c5c891ab0f4b6f897a2083cb";
    hash = "sha256-WF2b9t0VPGNP3QXgr/GMDFcSh5bsXC7KKd2ICL4WDHo=";
  };

  meta = {
    description = "Paste files into the hovered directory or to the CWD if hovering over a file";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
