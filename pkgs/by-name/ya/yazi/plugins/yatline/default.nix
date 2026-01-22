{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "25.5.31-unstable-2026-01-21";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    rev = "3227a30b21f69b68df513754b5a00d6e75cece57";
    hash = "sha256-yhptHABQ0alVab2i367D5grJyG7SrfHH8H4JuGeYFyk=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
