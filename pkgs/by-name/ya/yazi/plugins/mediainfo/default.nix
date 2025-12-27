{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "25.5.31-unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "af8bdf47a1f4dcfefe433aa2134b04eb9c75a10b";
    hash = "sha256-io3HyoUniWZu+0efZfbhXn8JoG5p2/lFeH/FguVvjSY=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
