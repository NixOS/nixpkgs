{stdenv, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv, sexplib}:

buildOcamlJane rec {
  name = "ppx_sexp_conv";
  hash = "1kgbmlc11w5jhbhmy5n0f734l44zwyry48342dm5qydi9sfzcgq2";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv sexplib];

  meta = with stdenv.lib; {
    description = "A ppx rewriter that defines an extension node whose value is its source position";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
