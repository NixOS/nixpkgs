{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  ocaml,
}:

buildDunePackage rec {
  pname = "memprof-limits";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "gadmm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pmuln5TihPoPZuehZlqPfERif6lf7O+0454kW9y3aKc=";
  };

  minimalOCamlVersion = "4.12";

  meta = with lib; {
    homepage = "https://ocaml.org/p/memprof-limits/latest";
    description = "Memory limits, allocation limits, and thread cancellation for OCaml";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ alizter ];
    broken = !(lib.versionOlder ocaml.version "5.0.0");
  };
}
