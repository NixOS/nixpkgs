{newBuildOcamlJane, base, ppx_compare, ppx_custom_printf, ppx_driver,
 ppx_fields_conv, ppx_sexp_conv, ppx_variants_conv, sexplib, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "bin_prot";
  hash = "0cy6lhksx4jypkrnj3ha31p97ghslki0bx5rpnzc2v28mfp6pzh1";

  propagatedBuildInputs = [ base ppx_compare ppx_custom_printf ppx_driver
    ppx_fields_conv ppx_sexp_conv ppx_variants_conv sexplib ocaml-migrate-parsetree ];

  meta.description = "Binary protocol generator";
}
