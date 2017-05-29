{newBuildOcamlJane, ppx_core, ppx_driver, ppx_metaquot, ppx_type_conv,
 variantslib, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_variants_conv";
  hash = "1xayhyglgbdjqvb9123kjbwjcv0a3n3302nb0j7g8gmja8w5y834";

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_metaquot ppx_type_conv
    variantslib ocaml-migrate-parsetree ];

  meta.description = "Generation of accessor and iteration functions for OCaml variant types";
}
