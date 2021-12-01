{lib, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv}:

buildOcamlJane {
  pname = "ppx_enumerate";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv ];

  meta = with lib; {
    description = "Generate a list containing all values of a finite type";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
