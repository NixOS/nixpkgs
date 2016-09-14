{stdenv, buildOcamlJane,
 ppx_compare, ppx_core, ppx_driver, ppx_here, ppx_sexp_conv, ppx_tools, ppx_type_conv, sexplib}:

buildOcamlJane rec {
  name = "ppx_assert";
  hash = "0n7fa1j79ykbkhp8xz0ksg5096asri5d0msshsaqhw5fz18chvz4";
  propagatedBuildInputs =
    [ ppx_compare ppx_core ppx_driver ppx_here ppx_sexp_conv ppx_tools
      ppx_type_conv sexplib ];

  meta = with stdenv.lib; {
    description = "Assert-like extension nodes that raise useful errors on failure";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
