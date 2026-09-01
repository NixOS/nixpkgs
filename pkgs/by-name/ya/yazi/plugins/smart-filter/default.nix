{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "smart-filter.yazi";
  version = "0-unstable-2026-07-04";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "5d461d85908338371b9433ab6c29707bee3a813b";
    hash = "sha256-vRElXxEe2Am7p6SoxJ7g8GSaka7/4/yZ2zfiOOqUR2I=";
  };

  meta = {
    description = "Yazi plugin that makes filters smarter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
