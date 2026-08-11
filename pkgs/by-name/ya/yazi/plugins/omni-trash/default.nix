{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "omni-trash.yazi";
  version = "0-unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "goon";
    repo = "omni-trash.yazi";
    rev = "3c2a9923673e0552a093afc4122473df1d427a93";
    hash = "sha256-heqqEWzJCoNt3CIJAEaWfqUX4J9BfVEw3OsU7Xjc17M=";
  };

  meta = {
    description = "Yazi plugin to manage your trash across all drives from a single, unified interface, powered by trash-cli";
    homepage = "https://github.com/goon/omni-trash.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
  };
}
