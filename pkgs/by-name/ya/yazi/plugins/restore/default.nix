{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "25.5.31-unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "4eda0bf047f014622348390d8db0e2e1b6d036f0";
    hash = "sha256-1qi7wnFAc8z9mFq1mbBQqQIsSe5uyTogmsSiNXS7F0w=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
