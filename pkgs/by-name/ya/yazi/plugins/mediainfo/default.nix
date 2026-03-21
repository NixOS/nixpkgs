{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "26.1.22-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "26a75daabe768347d45aa65be4c75cfb15772ef2";
    hash = "sha256-tE/ov1lF/bxxVCH00dXuWcjyjYkNpqeiMb0eIZ8Nwj4=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
