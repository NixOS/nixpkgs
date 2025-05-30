{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rsync.yazi";
  version = "0-unstable-2025-04-24";
  src = fetchFromGitHub {
    owner = "GianniBYoung";
    repo = "rsync.yazi";
    rev = "ed7b7f9de971ecd8376d7ccb7a6d0d6f979c1dcb";
    hash = "sha256-xAhkDTNi0MjHqESKk8j60WABYvaF7NElO2W/rsL2w2Y=";
  };

  meta = {
    description = "Simple rsync plugin for yazi file manager";
    homepage = "https://github.com/GianniBYoung/rsync.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
