{
  buildDunePackage,
  lablgtk,
  ocamlgraph,
  stdlib-shims,
  ...
}:

buildDunePackage {
  pname = "ocamlgraph_gtk";
  inherit (ocamlgraph) version src meta;

  propagatedBuildInputs = [
    lablgtk
    ocamlgraph
    stdlib-shims
  ];
}
