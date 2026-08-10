{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "0-unstable-2026-07-13";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "e079a001f4fefd69007e515bbede4e16b95a811e";
    hash = "sha256-RIVcKJO89R4oaE6sJuFcV8pFK4nvWtq6ILAXehu4FIY=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
