{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "25.5.31-unstable-2026-02-22";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "20ecff6dd154da4c6e28fc7f754e865fd5f9d1b3";
    hash = "sha256-br8UDDPxVe4ZfoHIURD2zzjmyUImhKak0DYwCF9r2vw=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
