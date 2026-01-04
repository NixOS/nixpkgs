{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mime-ext.yazi";
  version = "25.12.29-unstable-2025-12-30";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "da5b69563c67717c4bb422c9c72cc0cb9baa0632";
    hash = "sha256-LjlcAKlAZ/r4BDdcUGFX+e4LLZRHEH/jCsciKMs4QWg=";
  };

  meta = {
    description = "Mime-type provider based on a file extension database, replacing the builtin file to speed up mime-type retrieval at the expense of accuracy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
