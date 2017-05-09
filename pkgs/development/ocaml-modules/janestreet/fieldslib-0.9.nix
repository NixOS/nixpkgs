{newBuildOcamlJane, base, ppx_driver, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "fieldslib";
  hash = "1wxh59888l1bfz9ipnbcas58gwg744icaixzdbsg4v8f7wymc501";

  propagatedBuildInputs =
   [ base ppx_driver ocaml-migrate-parsetree ];

  meta.description = "OCaml record fields as first class values";
}
