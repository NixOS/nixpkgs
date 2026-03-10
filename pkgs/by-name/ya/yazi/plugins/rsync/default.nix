{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rsync.yazi";
  version = "0-unstable-2026-02-28";
  src = fetchFromGitHub {
    owner = "GianniBYoung";
    repo = "rsync.yazi";
    rev = "c094a5ce2dc2ebdb37f97a6f1f15af6c14c06402";
    hash = "sha256-SqN3jDwHtsVDqawJyYHWdndi9IaCKPJH9+d7ffX9H7c=";
  };

  meta = {
    description = "Simple rsync plugin for yazi file manager";
    homepage = "https://github.com/GianniBYoung/rsync.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
