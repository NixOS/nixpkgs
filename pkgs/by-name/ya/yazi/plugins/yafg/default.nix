{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yafg.yazi";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "yafg.yazi";
    rev = "bd03a32e7de7c718c966e21f800c23bd26b717cb";
    hash = "sha256-8LKyY0GpvcOlWavcaWKfvh/nQzcHMrnLeoStRGHCXrk=";
  };

  meta = {
    description = "Fuzzy find and grep plugin for Yazi file manager with interactive ripgrep and fzf search";
    homepage = "https://github.com/XYenon/yafg.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
