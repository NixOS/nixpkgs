{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "clipboard.yazi";
  version = "0-unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "clipboard.yazi";
    rev = "68b506d9a9c2c5dde01a078a589520f551d05fe5";
    hash = "sha256-jNBwkcFb9i5Z6BSMfkTOyrK7HZohAT/yB3cxcCOG54w=";
  };

  meta = {
    description = "Clipboard sync plugin for Yazi that copies yanked file paths to the system clipboard";
    homepage = "https://github.com/XYenon/clipboard.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
