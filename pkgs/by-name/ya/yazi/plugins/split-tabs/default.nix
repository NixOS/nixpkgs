{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "split-tabs.yazi";
  version = "0-unstable-2026-05-17";

  src = fetchFromGitHub {
    owner = "terrakok";
    repo = "split-tabs.yazi";
    rev = "da25bc0c02f669ef5d939bb03597f4ae557834ec";
    hash = "sha256-Xb8XKEEZgNL5dZ8EAy9ELDcYGWGq2go+bwdlpydifi8=";
  };

  meta = {
    description = "Yazi plugin that provides a dual-pane view by splitting the screen between two tabs";
    homepage = "https://github.com/terrakok/split-tabs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
