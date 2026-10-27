{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "clipboard.yazi";
  version = "0-unstable-2026-10-13";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "clipboard.yazi";
    rev = "4b4b6c513c555366744e03c16d7af481360be35f";
    hash = "sha256-R58Kn0K5CwCH7LGFBW0Sy7C/HAG39tWOhPafu+Gn+FA=";
  };

  meta = {
    description = "Clipboard sync plugin for Yazi that copies yanked file paths to the system clipboard";
    homepage = "https://github.com/XYenon/clipboard.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
