{newBuildOcamlJane, ppx_core}:

newBuildOcamlJane {
  name = "ppx_optcomp";
  hash = "1wfj6fnh92s81yncq7yyhmax7j6zpjj1sg1f3qa1f9c5kf4kkzrd";

  propagatedBuildInputs = [ ppx_core ];

  meta.description = "Optional compilation for OCaml";
}
