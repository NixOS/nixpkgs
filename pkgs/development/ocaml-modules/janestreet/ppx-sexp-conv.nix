{lib, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv, sexplib}:

buildOcamlJane {
  name = "ppx_sexp_conv";
  hash = "1kgbmlc11w5jhbhmy5n0f734l44zwyry48342dm5qydi9sfzcgq2";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv sexplib];

  meta = with lib; {
    description = "PPX syntax extension that generates code for converting OCaml types to and from s-expressions, as defined in the sexplib library";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
