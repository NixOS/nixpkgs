{
  lib,
  fetchurl,
  buildDunePackage,
  stdlib-shims,
}:

buildDunePackage rec {
  pname = "ocamlgraph";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/backtracking/ocamlgraph/releases/download/${version}/ocamlgraph-${version}.tbz";
    hash = "sha256-sJViEIY8wk9IAgO6PC7wbfrlV5U2oFdENk595YgisjA=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    stdlib-shims
  ];

  meta = with lib; {
    homepage = "https://github.com/backtracking/ocamlgraph";
    description = "Graph library for OCaml";
    license = licenses.gpl2Oss;
    maintainers = [ ];
  };
}
