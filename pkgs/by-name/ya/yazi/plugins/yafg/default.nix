{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yafg.yazi";
  version = "0-unstable-2026-01-10";

  src = fetchFromGitHub {
    owner = "XYenon";
    repo = "yafg.yazi";
    rev = "dd03b133d6cd1ff92368360558da193517169f9e";
    hash = "sha256-xTZ+6KRr85A4QpPWAE9QN1AnUVnCw/tvRvsWOmmayao=";
  };

  meta = {
    description = "Fuzzy find and grep plugin for Yazi file manager with interactive ripgrep and fzf search";
    homepage = "https://github.com/XYenon/yafg.yazi";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
