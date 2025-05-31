{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "25.5.28-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "c6d0de764f6e667c1a7a49f8acc9030c02a1a45c";
    hash = "sha256-CVHY66AcOC0STi+uDwbKe+HI3WN7MPgszlFHB479V/E=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
