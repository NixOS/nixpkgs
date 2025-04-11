{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "25.2.7-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "328dd888c1e2b9b0cb5dc806f099e3164e179620";
    hash = "sha256-3Z8P25u9bffdjrPjxLRWUQn6MdBS+vyElUBkgV4EUwY=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders.";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
