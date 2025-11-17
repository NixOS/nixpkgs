{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "recycle-bin.yazi";
  version = "0-unstable-2025-11-03";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "recycle-bin.yazi";
    rev = "bce0eb110e2447544fd619f30ff82bfee51a6347";
    hash = "sha256-dj/lKod8I6Fs1Vp2e6AOEmUVSwT12Ck7zT5e4Qsmzt0=";
  };

  meta = {
    description = "A Recycle Bin for Yazi with browse, restore, and cleanup capabilities";
    homepage = "https://github.com/uhs-robert/recycle-bin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guttermonk ];
    platforms = lib.platforms.linux;
  };
}
