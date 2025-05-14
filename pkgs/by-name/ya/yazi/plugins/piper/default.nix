{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "25.4.8-unstable-2025-04-21";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "71f925e4b7d6d2fa3e1e7822422d755ea709eb69";
    hash = "sha256-4XhVQ72JIfkT9A2hcE+3ch/xLEBe+HeFmjupy266OJo=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
