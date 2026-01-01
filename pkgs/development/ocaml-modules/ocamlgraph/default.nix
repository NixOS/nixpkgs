{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "ocamlgraph";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/backtracking/ocamlgraph/releases/download/${version}/ocamlgraph-${version}.tbz";
    hash = "sha256-sJViEIY8wk9IAgO6PC7wbfrlV5U2oFdENk595YgisjA=";
  };

  minimalOCamlVersion = "4.08";

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/backtracking/ocamlgraph";
    description = "Graph library for OCaml";
    license = lib.licenses.lgpl21Only;
=======
  meta = with lib; {
    homepage = "https://github.com/backtracking/ocamlgraph";
    description = "Graph library for OCaml";
    license = licenses.lgpl21Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
