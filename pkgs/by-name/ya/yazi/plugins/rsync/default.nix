{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rsync.yazi";
  version = "0-unstable-2026-03-07";
  src = fetchFromGitHub {
    owner = "GianniBYoung";
    repo = "rsync.yazi";
    rev = "44f6979e5739c04039b1a8b0a04b2e2cb6cde46c";
    hash = "sha256-54tXRwE1a+aq2cP4+ErXKQoHhUNx630sJZqiJpbrFT4=";
  };

  meta = {
    description = "Simple rsync plugin for yazi file manager";
    homepage = "https://github.com/GianniBYoung/rsync.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
