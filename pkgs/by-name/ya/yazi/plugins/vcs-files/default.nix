{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "babfd0f6144aedcc7af11852ce962b989d052898";
    hash = "sha256-y/UnRuZ2QytCdtGhxkbVvaGXglpqwufaUddXOzs7fzo=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
