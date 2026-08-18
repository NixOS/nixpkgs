{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "0-unstable-2026-08-17";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "3d25b6705fb1fb7967dfe393cf1b4a2926ebc40b";
    hash = "sha256-vEm2AO1tEHnsX93LlxBytjFFNnwpnoZd86WiVQf67BU=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
