{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "25.5.31-unstable-2025-06-05";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "a7d1aa69a1a107e64540c17f19ac94be1366769f";
    hash = "sha256-HUD8Sv1C4gzZRvSEIYqcmm+A0mBYDuwZHCNH26kipS0=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
