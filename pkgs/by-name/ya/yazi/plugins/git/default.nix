{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "3f2b8822aa77f8699d70803ef1407ef7a2a77b0d";
    hash = "sha256-ixdQLt8DJZRqoK4GqwaytxSrLGc+B5L+ILBs7eG6kLY=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
