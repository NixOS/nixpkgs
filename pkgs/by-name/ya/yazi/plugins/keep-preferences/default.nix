{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "keep-preferences.yazi";
  version = "0-unstable-2026-07-15";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "keep-preferences.yazi";
    rev = "0d32befc027b2ad31b8893bb2832f0f160442a0c";
    hash = "sha256-fdZIouyrWxcFGv51NVYylQRba6PGEzFqEP6mrUQiC9s=";
  };

  meta = {
    description = "Keep Yazi manager preferences per tab and per directory";
    homepage = "https://github.com/XYenon/keep-preferences.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
