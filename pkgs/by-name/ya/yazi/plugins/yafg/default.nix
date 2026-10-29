{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yafg.yazi";
  version = "0-unstable-2026-05-06";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "yafg.yazi";
    rev = "e6ba85125bfa4e3a60ef28b70949299712103b2a";
    hash = "sha256-IKQscTTirtfbsXKzCmaokPDrQZqXa4MSY2+6DbEQluU=";
  };

  meta = {
    description = "Fuzzy find and grep plugin for Yazi file manager with interactive ripgrep and fzf search";
    homepage = "https://github.com/XYenon/yafg.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
