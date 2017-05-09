{newBuildOcamlJane, ppx_core, ppx_driver, ppx_metaquot, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_type_conv";
  hash = "0a0gxjvjiql9vg37k0akn8xr5724nv3xb7v37xpidv7ld927ks7p";

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_metaquot ocaml-migrate-parsetree ];

  meta.description = "Support Library for type-driven code generators";
}
