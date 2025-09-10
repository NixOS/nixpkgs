{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bypass.yazi";
  version = "25.3.2-unstable-2025-06-01";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "c1e5fcf6eeed0bfceb57b9738da6db9d0fb8af56";
    hash = "sha256-ZndDtTMkEwuIMXG4SGe4B95Nw4fChfFhxJHj+IY30Kc=";
  };

  meta = {
    description = "Yazi plugin for skipping directories with only a single sub-directory";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
