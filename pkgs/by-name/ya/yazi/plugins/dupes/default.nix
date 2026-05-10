{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
  jdupes,
  bash,
}:
mkYaziPlugin {
  pname = "dupes.yazi";
  version = "0-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "mshnwq";
    repo = "dupes.yazi";
    rev = "1edf7a406410d5d18b4fbda7b3540e35ab3ad5d6";
    hash = "sha256-7x8N1heASHlYaLzzzdO4jm6IrTgqFbybp+I9EdF7c3M=";
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
