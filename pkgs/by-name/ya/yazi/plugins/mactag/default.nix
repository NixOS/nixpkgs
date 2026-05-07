{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mactag.yazi";
  version = "26.1.22-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "babfd0f6144aedcc7af11852ce962b989d052898";
    hash = "sha256-y/UnRuZ2QytCdtGhxkbVvaGXglpqwufaUddXOzs7fzo=";
  };

  meta = {
    description = "Bring macOS's awesome tagging feature to Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.darwin;
  };
}
