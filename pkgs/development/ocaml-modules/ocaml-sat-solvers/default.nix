{
  lib,
  fetchurl,
  buildDunePackage,
  minisat,
}:

buildDunePackage (finalAttrs: {
  pname = "ocaml-sat-solvers";
  version = "0.8";

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/tcsprojects/ocaml-sat-solvers/releases/download/v${finalAttrs.version}/ocaml-sat-solvers-${finalAttrs.version}.tbz";
    hash = "sha256-1eXzuY6rrrjdEG/XnkJe4o9zAcUvfTVFO1+ZIzcgpOU=";
  };

  propagatedBuildInputs = [ minisat ];

  meta = {
    homepage = "https://github.com/tcsprojects/ocaml-sat-solvers";
    description = "SAT Solvers For OCaml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
})
