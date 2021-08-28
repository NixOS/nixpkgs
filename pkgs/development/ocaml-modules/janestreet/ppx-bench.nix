{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_inline_test, ppx_tools}:

buildOcamlJane {
  name = "ppx_bench";
  minimumSupportedOcamlVersion = "4.02";
  hash = "1l5jlwy1d1fqz70wa2fkf7izngp6nx3g4s9bmnd6ca4dx1x5bksk";

  hasSharedObjects = true;

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_inline_test ppx_tools ];

  meta = with lib; {
    description = "Syntax extension for writing in-line benchmarks in ocaml code";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
