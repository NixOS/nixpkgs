{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "25.12.29-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "03cdd4b5b15341b3c0d0f4c850d633fadd05a45f";
    hash = "sha256-5dMAJ6W/L66XuH4CCwRRFpKSLy0ZDFIABAYleFX0AsQ=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
