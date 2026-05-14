{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "split-tabs.yazi";
  version = "0-unstable-2026-05-13";

  src = fetchFromGitHub {
    owner = "terrakok";
    repo = "split-tabs.yazi";
    rev = "ca95efc94a3a62e6e58c741f60801c1a0ddba1a6";
    hash = "sha256-ic09opWZcoJ874bU2HN+5Y9mbnZEnvds+abqRQYuiYE=";
  };

  meta = {
    description = "Yazi plugin that provides a dual-pane view by splitting the screen between two tabs";
    homepage = "https://github.com/terrakok/split-tabs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
