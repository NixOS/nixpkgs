{newBuildOcamlJane, ppx_core, ppx_driver, ppx_metaquot, ppx_type_conv,
 sexplib, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_sexp_conv";
  hash = "03cg2sym0wvpd5l7q4w9bclp589z5byygwsmnnq9h1ih56cmd55l";

  propagatedBuildInputs =
   [ ppx_core ppx_driver ppx_metaquot ppx_type_conv sexplib ocaml-migrate-parsetree ];

  meta.description = "Generation of S-expression conversion functions from type definitions";
}
