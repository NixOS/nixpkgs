{newBuildOcamlJane, base, ocaml-compiler-libs, ppx_ast,
 ppx_traverse_builtins, stdio}:

newBuildOcamlJane {
  name = "ppx_core";
  hash = "15400zxxkqdimmjpdjcs36gcbxbrhylmaczlzwd6x65v1h9aydz3";

  propagatedBuildInputs =
   [ base ocaml-compiler-libs ppx_ast ppx_traverse_builtins stdio ];

  meta.description = "Jane Street's standard library for ppx rewriters";
}
