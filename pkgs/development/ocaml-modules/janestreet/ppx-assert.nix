{lib, buildOcamlJane,
 ppx_compare, ppx_core, ppx_driver, ppx_here, ppx_sexp_conv, ppx_tools, ppx_type_conv, sexplib}:

buildOcamlJane {
  pname = "ppx_assert";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs =
    [ ppx_compare ppx_core ppx_driver ppx_here ppx_sexp_conv ppx_tools
      ppx_type_conv sexplib ];

  meta = with lib; {
    description = "Assert-like extension nodes that raise useful errors on failure";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
