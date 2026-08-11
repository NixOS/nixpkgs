{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "0-unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b9598e6cbe721aa29bf64836ce314584cfeb58fc";
    hash = "sha256-mrQq3r1dzM3DmEyke8CvSLbacgLQ4tNiqYHCOyXaqp0=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
