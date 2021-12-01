{lib, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv, typerep}:

buildOcamlJane {
  pname = "ppx_typerep_conv";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv typerep ];

  meta = with lib; {
    description = "Automatic generation of runtime types from type definitions";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
