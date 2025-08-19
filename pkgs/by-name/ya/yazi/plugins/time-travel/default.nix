{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "time-travel.yazi";
  version = "0-unstable-2025-02-14";

  src = fetchFromGitHub {
    owner = "iynaix";
    repo = "time-travel.yazi";
    rev = "7e0179e15a41a4a42b6d0b5fa6dd240c9b4cf0d2";
    hash = "sha256-ZZgn5rsBzvZcnDWZfjMBPRg9QUz4FTq5UIPWfnwXHQs=";
  };

  meta = {
    description = "Yazi plugin for browsing backwards and forwards in time via BTRFS / ZFS snapshots";
    homepage = "https://github.com/iynaix/time-travel.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
