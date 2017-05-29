{newBuildOcamlJane, ppx_core, ppx_driver, ppx_metaquot, ppx_type_conv, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_traverse";
  hash = "1sdqgwyq0w71i03vhc5jq4jk6rsbgwhvain48fnrllpkb5kj2la2";

  propagatedBuildInputs =
   [ ppx_core ppx_driver ppx_metaquot ppx_type_conv ocaml-migrate-parsetree ];

  meta.description = "Automatic generation of open recursion classes";
}
