{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "time-travel.yazi";
  version = "0-unstable-2026-10-15";

  src = fetchFromGitHub {
    owner = "iynaix";
    repo = "time-travel.yazi";
    rev = "1cd63a06831b73098fb74e271700f00b6bb439da";
    hash = "sha256-l5P1A4agmhQGX0Qdni2pL0FQNwFHe5OJgELnKADrqls=";
  };

  meta = {
    description = "Yazi plugin for browsing backwards and forwards in time via BTRFS / ZFS snapshots";
    homepage = "https://github.com/iynaix/time-travel.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
