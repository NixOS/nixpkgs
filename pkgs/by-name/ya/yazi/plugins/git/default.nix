{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "25.12.29-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "e07bf41442a7f6fdd003069f380e1ae469a86211";
    hash = "sha256-aC8DUZpzNHEf9MW3tX3XcDYY/mWClAHkw+nZaxDQHp8=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
