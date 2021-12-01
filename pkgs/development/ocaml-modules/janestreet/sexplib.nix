{lib, buildOcamlJane, type_conv}:

buildOcamlJane {
  minimumSupportedOcamlVersion = "4.02";
  pname = "sexplib";
  version = "113.33.03";

  hash = "0000000000000000000000000000000000000000000000000000";

  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://ocaml.janestreet.com/";
    description = "Library for serializing OCaml values to and from S-expressions";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
