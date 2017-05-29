{newBuildOcamlJane, ppx_core, ppx_driver, ppx_traverse_builtins, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_metaquot";
  hash = "15qfd3s4x2pz006nx5316laxd3gqqi472x432qg4rfx4yh3vn31k";

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_traverse_builtins ocaml-migrate-parsetree ];

  meta.description = "Metaquotations for ppx_ast";
}
