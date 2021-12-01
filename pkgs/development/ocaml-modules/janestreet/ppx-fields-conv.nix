{lib, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv}:

buildOcamlJane {
  pname = "ppx_fields_conv";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv ];

  meta = with lib; {
    description = "Generation of accessor and iteration functions for ocaml records";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
