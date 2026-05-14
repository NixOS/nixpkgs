{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "split-tabs.yazi";
  version = "0-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "terrakok";
    repo = "split-tabs.yazi";
    rev = "6c0931840d764bffa0c38677b6a84e69928e283f";
    hash = "sha256-FqeXVVFk4+aXn8d+LLs8idRBkLLzRPeVol6vMCh6mQ4=";
  };

  meta = {
    description = "Yazi plugin that provides a dual-pane view by splitting the screen between two tabs";
    homepage = "https://github.com/terrakok/split-tabs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
