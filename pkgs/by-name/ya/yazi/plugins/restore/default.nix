{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "25.2.7-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "539aad5077dc8b342a580036e416f2b949b6590e";
    hash = "sha256-ngwbweKF7pSEpzy1TNzbKz8cFIWaDison5vCiGxkHFk=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
