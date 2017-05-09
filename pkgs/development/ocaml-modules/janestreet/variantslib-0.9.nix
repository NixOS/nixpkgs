{newBuildOcamlJane, ppx_driver, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "variantslib";
  hash = "0kj53n62193j58q9vip8lfhhyf6w9d25wyvxzc163hx5m68yw0fz";

  propagatedBuildInputs = [ ppx_driver ocaml-migrate-parsetree ];

  meta.description = "OCaml variants as first class values";
}
