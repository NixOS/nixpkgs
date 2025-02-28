{
  buildDunePackage,
  lablgtk,
  ocamlgraph,
  stdlib-shims,
  ...
}:

buildDunePackage rec {
  pname = "ocamlgraph_gtk";
  inherit (ocamlgraph) version src meta;

  propagatedBuildInputs = [
    lablgtk
    ocamlgraph
    stdlib-shims
  ];
}
