{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mime-ext.yazi";
  version = "25.5.28-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "d642bfb0822eb0c3c5c891ab0f4b6f897a2083cb";
    hash = "sha256-WF2b9t0VPGNP3QXgr/GMDFcSh5bsXC7KKd2ICL4WDHo=";
  };

  meta = {
    description = "Mime-type provider based on a file extension database, replacing the builtin file to speed up mime-type retrieval at the expense of accuracy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
