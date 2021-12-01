{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_inline_test, ppx_tools}:

buildOcamlJane {
  pname = "ppx_bench";
  minimumSupportedOcamlVersion = "4.02";
  hash = "0000000000000000000000000000000000000000000000000000";

  hasSharedObjects = true;

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_inline_test ppx_tools ];

  meta = with lib; {
    description = "Syntax extension for writing in-line benchmarks in ocaml code";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
