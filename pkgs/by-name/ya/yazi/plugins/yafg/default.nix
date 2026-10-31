{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yafg.yazi";
  version = "0-unstable-2026-10-05";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "yafg.yazi";
    rev = "1202b2ca9ebb7bf537927ba07df1aa96ff532502";
    hash = "sha256-CsJuHn4L6rhsrTKFzIuQWtDp0uj+kUsCri1UogMA2n0=";
  };

  meta = {
    description = "Fuzzy find and grep plugin for Yazi file manager with interactive ripgrep and fzf search";
    homepage = "https://github.com/XYenon/yafg.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
