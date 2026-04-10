{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "26.1.22-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "0897e20d41b79a5ec8e80e645b041bb950547a0b";
    hash = "sha256-tHOHWFH9E7aGrmHb8bUD1sLGU0OIdTjQ2p4SbJVfh/s=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
