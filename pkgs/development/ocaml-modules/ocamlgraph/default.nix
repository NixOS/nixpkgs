{
  lib,
  fetchurl,
  buildDunePackage,
  stdlib-shims,
}:

buildDunePackage rec {
  pname = "ocamlgraph";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/backtracking/ocamlgraph/releases/download/${version}/ocamlgraph-${version}.tbz";
    hash = "sha256-D5YsNvklPfI5OVWvQbB0tqQmsvkqne95WyAFtX0wLWU=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    stdlib-shims
  ];

  meta = {
    homepage = "https://github.com/backtracking/ocamlgraph";
    description = "Graph library for OCaml";
    license = lib.licenses.gpl2Oss;
    maintainers = [ ];
  };
}
