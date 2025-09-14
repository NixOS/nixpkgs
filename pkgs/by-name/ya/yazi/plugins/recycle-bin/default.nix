{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "recycle-bin.yazi";
  version = "0-unstable-2025-09-08";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "recycle-bin.yazi";
    rev = "728c0af4111ad043f9361ce6373949b5f9dec4a3";
    hash = "sha256-XnDiWuKLyI1jszwKTaVnPR8AX3+9mdkkof+V6E8RkR4=";
  };

  meta = {
    description = "A Recycle Bin for Yazi with browse, restore, and cleanup capabilities";
    homepage = "https://github.com/uhs-robert/recycle-bin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guttermonk ];
    platforms = lib.platforms.linux;
  };
}
