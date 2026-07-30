{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "restore.yazi";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "restore.yazi";
    rev = "7bfcfcbda078b7e51d1ff9a62db9c654a3952fa4";
    hash = "sha256-pmyS1rU5C6U9LloGoDFB8s6GwoMqG1Jve5OFooI64tU=";
  };

  meta = {
    description = "Undo/Recover trashed files/folders";
    homepage = "https://github.com/boydaihungst/restore.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
