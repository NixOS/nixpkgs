{lib, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv, bin_prot}:

buildOcamlJane {
  pname = "ppx_bin_prot";
  hash = "0000000000000000000000000000000000000000000000000000";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv bin_prot ];

  meta = with lib; {
    description = "Generation of bin_prot readers and writers from types";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
