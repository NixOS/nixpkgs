{newBuildOcamlJane, fieldslib, ppx_core, ppx_driver, ppx_metaquot,
 ppx_type_conv, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_fields_conv";
  hash = "0qp8zgmk58iskzrkf4g06i471kg6lrh3wqpy9klrb8pp9mg0xr9z";

  propagatedBuildInputs = [ fieldslib ppx_core ppx_driver ppx_metaquot
    ppx_type_conv ocaml-migrate-parsetree ];

  meta.description = "Generation of accessor and iteration functions for OCaml records";
}
