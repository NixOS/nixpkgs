{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "25.5.31-unstable-2025-09-25";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "2161735f840e36974a6b4b0007c3e4184a085208";
    hash = "sha256-W3P7UhEtmv0JfcKUd+g/HBPy4ML8qgmgnOVaYKN0TSU=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
