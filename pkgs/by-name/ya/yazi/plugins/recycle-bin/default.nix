{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "recycle-bin.yazi";
  version = "0-unstable-2026-01-17";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "recycle-bin.yazi";
    rev = "fa687116c46a784e664ef96619b32abf51f29b06";
    hash = "sha256-lpxTGWA15szM5VJ+qvV2+GTg7HXiZaZfyWyjeNMsTSM=";
  };

  meta = {
    description = "A Recycle Bin for Yazi with browse, restore, and cleanup capabilities";
    homepage = "https://github.com/uhs-robert/recycle-bin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guttermonk ];
    platforms = lib.platforms.linux;
  };
}
