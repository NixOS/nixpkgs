{lib, buildOcamlJane,
 ppx_core, ppx_driver}:

buildOcamlJane {
  pname = "ppx_here";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_driver ];

  meta = with lib; {
    description = "A ppx rewriter that defines an extension node whose value is its source position";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
