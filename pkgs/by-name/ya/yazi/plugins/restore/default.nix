{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "25.4.8-unstable-2025-05-19";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "1bfd5f71cb59bebde192126e2255bf4dc9f3b249";
    hash = "sha256-JaeJxFnLqZZGduSwwvGD3q1bdJUSEyu0W6EI+4Hwwc0=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
