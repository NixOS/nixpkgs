{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "time-travel.yazi";
  version = "0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "iynaix";
    repo = "time-travel.yazi";
    rev = "aaec6e26e525bd146354a5137ec40f1f23257a4e";
    hash = "sha256-/+KiuGUox763dMQvHl1l3+Ci3vL8NwRuKNu9pi3gjyE=";
  };

  meta = {
    description = "Yazi plugin for browsing backwards and forwards in time via BTRFS / ZFS snapshots";
    homepage = "https://github.com/iynaix/time-travel.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
