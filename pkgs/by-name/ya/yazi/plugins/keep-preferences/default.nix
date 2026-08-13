{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "keep-preferences.yazi";
  version = "0-unstable-2026-08-05";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "keep-preferences.yazi";
    rev = "5ff553eab2ca15014cd07a8cdf93cc0063be0d6f";
    hash = "sha256-oeiumvTouv7k0JJxY7NuOqfiFDzOgIUOQO/G/2sYC1E=";
  };

  meta = {
    description = "Keep Yazi manager preferences per tab and per directory";
    homepage = "https://github.com/XYenon/keep-preferences.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
