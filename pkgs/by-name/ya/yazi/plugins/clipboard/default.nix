{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "clipboard.yazi";
  version = "0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "clipboard.yazi";
    rev = "d6fc53152a20aebad8dc6e2550940f7efe226838";
    hash = "sha256-6jlMzVPgkbQRwVbfUCEtXVWLxBKdPymQeHVoh5z9mO8=";
  };

  meta = {
    description = "Clipboard sync plugin for Yazi that copies yanked file paths to the system clipboard";
    homepage = "https://github.com/XYenon/clipboard.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
