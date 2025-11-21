{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "25.5.31-unstable-2025-11-19";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "2301ff803a033cd16d16e62697474d6cb9a94711";
    hash = "sha256-+lirIBXv3EvztE/1b3zHnQ9r5N3VWBCUuH3gZR52fE0=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
