{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "25.4.4-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "9a095057d698aaaedc4dd23d638285bd3fd647e9";
    hash = "sha256-Lx+TliqMuaXpjaUtjdUac7ODg2yc3yrd1mSWJo9Mz2Q=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
