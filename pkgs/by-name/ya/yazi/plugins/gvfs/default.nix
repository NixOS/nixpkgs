{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "gvfs.yazi";
  version = "0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "gvfs.yazi";
    rev = "c92953ca74fc8b67830548e3a91d9fda3dc57433";
    hash = "sha256-kg8ds6T3sywoioYq/7X1osmPmTliszG9XaC0vmZsGRM=";
  };

  meta = {
    description = "Transparently mount and unmount devices or remote storage in read and write mode";
    homepage = "https://github.com/boydaihungst/gvfs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    platforms = lib.platforms.linux;
  };
}
