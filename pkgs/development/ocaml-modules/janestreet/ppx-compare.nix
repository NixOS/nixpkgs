{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_tools, ppx_type_conv}:

buildOcamlJane {
  pname = "ppx_compare";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs =
    [ppx_core ppx_driver ppx_tools ppx_type_conv ];

  meta = with lib; {
    description = "Generation of fast comparison functions from type expressions and definitions";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
