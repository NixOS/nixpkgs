{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bypass.yazi";
  version = "0-unstable-2026-05-17";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "4a0c70ec9122d884deb659ff620af0098314c136";
    hash = "sha256-kho114UcjV90BDghZxUn2gZXtjY0tsE+C9ttlQZli6U=";
  };

  meta = {
    description = "Yazi plugin for skipping directories with only a single sub-directory";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
