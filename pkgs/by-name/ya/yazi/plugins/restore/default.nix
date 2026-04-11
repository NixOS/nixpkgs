{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "25.5.31-unstable-2026-04-04";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "0e0870460b9b74c5ae98b7f96c7c26a9a274ce6d";
    hash = "sha256-rDsyMF5IEBHx+fJ0oYTCCQAlTSquUcOkFLC4Lmbuz6k=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
