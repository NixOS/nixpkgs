{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_sexp_conv, ppx_tools}:

buildOcamlJane {
  pname = "ppx_custom_printf";
  hash = "0000000000000000000000000000000000000000000000000000";

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_sexp_conv ppx_tools ];

  meta = with lib; {
    description = "Extensions to printf-style format-strings for user-defined string conversion";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
