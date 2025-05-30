{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "torrent-preview.yazi";
  version = "0-unstable-2025-05-22";

  src = fetchFromGitHub {
    owner = "kirasok";
    repo = "torrent-preview.yazi";
    rev = "4ca5996a8264457cbefff8e430acfca4900a0453";
    hash = "sha256-vaeOdNa56wwzBV6DgJjprRlrAcz2yGUYsOveTJKFv6M=";
  };

  meta = {
    description = "yazi plugin to preview bittorrent files";
    homepage = "https://github.com/kirasok/torrent-preview.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felipe-9 ];
  };
}
