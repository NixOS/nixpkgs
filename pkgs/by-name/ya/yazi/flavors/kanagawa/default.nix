{
  lib,
  fetchFromGitHub,
  mkYaziFlavor,
}:
mkYaziFlavor {
  pname = "kanagawa.yazi";
  version = "0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "dangooddd";
    repo = "kanagawa.yazi";
    rev = "04985d12842b06bdb3ad5f1b3d7abc631059b7f5";
    hash = "sha256-Yz0zRVzmgbrk0m7OkItxIK6W0WkPze/t09pWFgziNrw=";
  };

  meta = {
    description = "Kanagawa theme for Yazi";
    homepage = "https://github.com/dangooddd/kanagawa.yazi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.es-sai-fi ];
  };
}
