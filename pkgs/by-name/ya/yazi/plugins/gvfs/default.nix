{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "gvfs.yazi";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "gvfs.yazi";
    rev = "364b0a811d722a1fdb3c2bde36aa640591437967";
    hash = "sha256-bQDcT04m1WvMRCiVIyer4WHgjYMaamMfolmH49lVSig=";
  };

  meta = {
    description = "Transparently mount and unmount devices or remote storage in read and write mode";
    homepage = "https://github.com/boydaihungst/gvfs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    platforms = lib.platforms.linux;
  };
}
