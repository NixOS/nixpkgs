{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "gvfs.yazi";
  version = "25.5.31-unstable-2026-03-24";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "gvfs.yazi";
    rev = "a908b623aef9c93b9921ce9b16cf50f0f3da0091";
    hash = "sha256-3BM1XT1Kk0nXBwZ76MPfEHoYW0+4NXvB5o6Nlf+VL9g=";
  };

  meta = {
    description = "Transparently mount and unmount devices or remote storage in read and write mode";
    homepage = "https://github.com/boydaihungst/gvfs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    platforms = lib.platforms.linux;
  };
}
