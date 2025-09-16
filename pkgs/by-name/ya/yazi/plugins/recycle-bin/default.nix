{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "recycle-bin.yazi";
  version = "0-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "recycle-bin.yazi";
    rev = "2bd3c588adee5388afe08faea59e8e5437f5adb6";
    hash = "sha256-hc3K8WUWeptLloDYsZzZfKJyk5J6iyVjuijnUe1fUCM=";
  };

  meta = {
    description = "A Recycle Bin for Yazi with browse, restore, and cleanup capabilities";
    homepage = "https://github.com/uhs-robert/recycle-bin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guttermonk ];
    platforms = lib.platforms.linux;
  };
}
