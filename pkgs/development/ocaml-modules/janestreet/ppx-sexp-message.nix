{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_here, ppx_sexp_conv, ppx_tools}:

buildOcamlJane {
  pname = "ppx_sexp_message";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_driver ppx_here ppx_sexp_conv ppx_tools ];

  meta = with lib; {
    description = "Easy construction of S-Expressions";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
