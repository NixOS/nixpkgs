{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "26.1.22-unstable-2026-01-24";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "6c71385af67c71cb3d62359e94077f2e940b15df";
    hash = "sha256-+akz8E6Fmk6KwmeZOePEm/KqfbDaKeL4wiUgtm12SAE=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
