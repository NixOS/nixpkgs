{ buildDunePackage, lablgtk, ocamlgraph, stdlib-shims, ... }:

buildDunePackage rec {
  pname = "ocamlgraph_gtk";
  inherit (ocamlgraph) version src useDune2 meta;

  propagatedBuildInputs = [
    lablgtk
    ocamlgraph
    stdlib-shims
  ];
}
