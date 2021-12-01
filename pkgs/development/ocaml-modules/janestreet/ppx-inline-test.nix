{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_tools}:

buildOcamlJane {
  pname = "ppx_inline_test";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_driver ppx_tools ];

  meta = with lib; {
    description = "Syntax extension for writing in-line tests in ocaml code";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
