{newBuildOcamlJane, ocamlbuild, ppx_core, ppx_optcomp, ocaml-migrate-parsetree}:

newBuildOcamlJane {
  name = "ppx_driver";
  hash = "1w3khwnvy18nkh673zrbhcs6051hs7z5z5dib7npkvpxndw22hwj";

  buildInputs = [ ocamlbuild ];

  propagatedBuildInputs = [ ppx_core ppx_optcomp ocaml-migrate-parsetree ];

  meta.description = "Feature-full driver for OCaml AST transformers";
}
