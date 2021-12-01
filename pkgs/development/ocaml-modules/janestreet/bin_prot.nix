{lib, buildOcamlJane, type_conv}:

buildOcamlJane {
  pname = "bin_prot";
  version = "113.33.03";
  minimumSupportedOcamlVersion = "4.02";
  hash = "0000000000000000000000000000000000000000000000000000";

  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/bin_prot";
    description = "Binary protocol generator ";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
