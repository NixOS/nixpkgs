{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "keep-preferences.yazi";
  version = "0-unstable-2026-05-15";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "keep-preferences.yazi";
    rev = "f6656322e059df2384b1e3b37461e362438879f9";
    hash = "sha256-eRlF78sixUVHWuYFml65xY7W0rKGDholqpggUuatd1c=";
  };

  meta = {
    description = "Keep Yazi manager preferences per tab and per directory";
    homepage = "https://github.com/XYenon/keep-preferences.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
