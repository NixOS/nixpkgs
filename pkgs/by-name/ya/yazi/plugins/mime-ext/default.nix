{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mime-ext.yazi";
  version = "25.4.4-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "9a095057d698aaaedc4dd23d638285bd3fd647e9";
    hash = "sha256-Lx+TliqMuaXpjaUtjdUac7ODg2yc3yrd1mSWJo9Mz2Q=";
  };

  meta = {
    description = "Mime-type provider based on a file extension database, replacing the builtin file to speed up mime-type retrieval at the expense of accuracy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
