{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "clipboard.yazi";
  version = "0-unstable-2026-09-25";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "clipboard.yazi";
    rev = "a2655fde94dbbea56aa0230a300ab64503df53f4";
    hash = "sha256-Jh8mZQjU5bzo9yly36M6b3Jfz4bIUdMSIS43VM/i/j4=";
  };

  meta = {
    description = "Clipboard sync plugin for Yazi that copies yanked file paths to the system clipboard";
    homepage = "https://github.com/XYenon/clipboard.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
