{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "clipboard.yazi";
  version = "0-unstable-2026-07-14";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "clipboard.yazi";
    rev = "4533c7f1b16196ad32749e35344bdc82a624871b";
    hash = "sha256-lThDO1b9iq+N6x/F9fKEWlNPpgJBTfxpY2xjyZF22mM=";
  };

  meta = {
    description = "Clipboard sync plugin for Yazi that copies yanked file paths to the system clipboard";
    homepage = "https://github.com/XYenon/clipboard.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
