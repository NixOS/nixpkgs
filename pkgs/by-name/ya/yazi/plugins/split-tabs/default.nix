{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "split-tabs.yazi";
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "terrakok";
    repo = "split-tabs.yazi";
    rev = "3f297277ed79cef5d22ea19883ce4d22e40c45a8";
    hash = "sha256-exa9I5GaF5T2dBnKIcB1gSdtdp2QlzbHv2J9FGxfpBM=";
  };

  meta = {
    description = "Yazi plugin that provides a dual-pane view by splitting the screen between two tabs";
    homepage = "https://github.com/terrakok/split-tabs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
