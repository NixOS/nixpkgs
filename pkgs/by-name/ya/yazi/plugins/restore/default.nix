{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "25.5.31-unstable-2025-07-11";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "84f1921806c49b7b20af26cbe57cb4fd286142e2";
    hash = "sha256-pEQZ/2Z4XVYlfzqtCz51bIgE9KzkDF/qyX8vThhlWGI=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
