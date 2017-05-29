{newBuildOcamlJane, base, ppx_core, ppx_driver, ppx_metaquot, ppx_type_conv,
 ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_compare";
  hash = "0wrszpvn1nms5sb5rb29p7z1wmqyd15gfzdj4ax8f843p5ywx3w9";

  propagatedBuildInputs =
   [ base ppx_core ppx_driver ppx_metaquot ppx_type_conv ocaml-migrate-parsetree ];

  meta.description = "Generation of comparison functions from types";
}
