{lib, buildOcamlJane, type_conv}:

buildOcamlJane {
  pname = "variantslib";
  version = "113.33.03";

  minimumSupportedOcamlVersion = "4.00";

  hash = "0000000000000000000000000000000000000000000000000000";

  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/variantslib";
    description = "OCaml variants as first class values";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
