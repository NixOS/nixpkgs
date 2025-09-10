{
  buildDunePackage,
  lablgtk,
  ocamlgraph,
}:

buildDunePackage {
  pname = "ocamlgraph_gtk";
  inherit (ocamlgraph) version src meta;

  propagatedBuildInputs = [
    lablgtk
    ocamlgraph
  ];
}
