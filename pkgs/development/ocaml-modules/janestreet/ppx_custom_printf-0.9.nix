{newBuildOcamlJane, ppx_core, ppx_driver, ppx_metaquot, ppx_sexp_conv,
 ppx_traverse, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_custom_printf";
  hash = "0cjy2c2c5g3qxqvwx1yb6p7kbmmpnpb1hll55f7a44x215lg8x19";

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_metaquot
    ppx_sexp_conv ppx_traverse ocaml-migrate-parsetree ];

  meta.description = "Printf-style format-strings for user-defined string conversion";
}
