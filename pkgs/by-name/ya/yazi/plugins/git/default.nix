{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "1db18bb5a1c962f95873654a7af1202abb98da60";
    hash = "sha256-kcZGQB8Dfon8OipuAcNnCeRgTp/S0mQokADkuvEG4Lc=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
