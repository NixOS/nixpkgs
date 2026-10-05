{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "keep-preferences.yazi";
  version = "0-unstable-2026-09-24";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "keep-preferences.yazi";
    rev = "1e1fa5849a48690ff1398263c9595c31b618fe6f";
    hash = "sha256-1pYrW7TzdkDTyh8uEGYyWROpPK3HxweJJbPxbreaE/w=";
  };

  meta = {
    description = "Keep Yazi manager preferences per tab and per directory";
    homepage = "https://github.com/XYenon/keep-preferences.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
