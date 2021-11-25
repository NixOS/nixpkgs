{ lib, fetchurl, buildDunePackage, stdlib-shims }:

buildDunePackage rec {
  pname = "ocamlgraph";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/backtracking/ocamlgraph/releases/download/${version}/ocamlgraph-${version}.tbz";
    sha256 = "029692bvdz3hxpva9a2jg5w5381fkcw55ysdi8424lyyjxvjdzi0";
  };

  minimalOCamlVersion = "4.03";
  useDune2 = true;

  propagatedBuildInputs = [
    stdlib-shims
  ];

  meta = with lib; {
      homepage = "http://ocamlgraph.lri.fr/";
      downloadPage = "https://github.com/backtracking/ocamlgraph";
      description = "Graph library for OCaml";
      license = licenses.gpl2Oss;
      maintainers = with maintainers; [ kkallio ];
  };
}
