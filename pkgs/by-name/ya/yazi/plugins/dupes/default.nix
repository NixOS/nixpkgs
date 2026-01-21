{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
  jdupes,
  bash,
}:
mkYaziPlugin {
  pname = "dupes.yazi";
  version = "0-unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "dupes.yazi";
    rev = "18a9395d38f42e406805b92834154fc7ad15a7b8";
    hash = "sha256-hBpUoMKGZgKrgxAOYZQ9CU4BKPSiYpYVWyuHYXHZ/Pc=";
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
