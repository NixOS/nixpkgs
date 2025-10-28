{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
  jdupes,
  bash,
}:
mkYaziPlugin {
  pname = "dupes.yazi";
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "dupes.yazi";
    rev = "012a21e1864296503f7bb1e7297b71fe57af8994";
    hash = "sha256-VUF7vmtnXuEsbyS0/pPTgwrDDrnMqt77eIkeQZFxoZk=";
  };

  postPatch = ''
    substituteInPlace main.lua --replace-fail \
      'set_state("cmdline", "jdupes")' \
      'set_state("cmdline", "${lib.getExe jdupes}")'
    substituteInPlace main.lua --replace-fail \
      'set_state("shell", "bash")' \
      'set_state("shell", "${lib.getExe bash}")'
  '';

  meta = {
    description = "Duplicate files plugin for Yazi";
    homepage = "https://github.com/Mshnwq/dupes.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mshnwq ];
  };
}
