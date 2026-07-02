{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "keep-preferences.yazi";
  version = "0-unstable-2026-05-25";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "keep-preferences.yazi";
    rev = "45d93faa8f1da3f4c2fabf68398204fd576705f7";
    hash = "sha256-uNReRmj9slKE/7WYA0gfE5eTO60CdFrFMH1/V3GwvFg=";
  };

  meta = {
    description = "Keep Yazi manager preferences per tab and per directory";
    homepage = "https://github.com/XYenon/keep-preferences.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
