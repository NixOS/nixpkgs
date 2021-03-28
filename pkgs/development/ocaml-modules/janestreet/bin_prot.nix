{lib, buildOcamlJane, type_conv}:

buildOcamlJane {
  name = "bin_prot";
  version = "113.33.03";
  minimumSupportedOcamlVersion = "4.02";
  hash = "0jlarpfby755j0kikz6vnl1l6q0ga09b9zrlw6i84r22zchnqdsh";

  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/bin_prot";
    description = "Binary protocol generator ";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
