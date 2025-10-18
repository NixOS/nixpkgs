{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
  jdupes,
}:
mkYaziPlugin {
  pname = "dupes.yazi";
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "dupes.yazi";
    rev = "4666b6f299c2257c011f622319ae97fab8adbabe";
    hash = "sha256-v9xuSY/i/trIHHbOPbijd0AmcUb2vufNL9BSjBE6+Vo=";
  };

  postPatch = ''
    substituteInPlace main.lua --replace-fail \
      'set_state("cmdline", "jdupes")' \
      'set_state("cmdline", "${lib.getExe jdupes}")'
  '';

  meta = {
    description = "Duplicate files plugin for Yazi";
    homepage = "https://github.com/Mshnwq/dupes.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mshnwq ];
  };
}
