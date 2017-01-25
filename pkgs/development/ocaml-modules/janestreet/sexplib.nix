{stdenv, buildOcamlJane, type_conv}:

buildOcamlJane rec {
  minimumSupportedOcamlVersion = "4.02";
  name = "sexplib";
  version = "113.33.03";

  hash = "1klar4qw4s7bj47ig7kxz2m4j1q3c60pfppis4vxrxv15r0kfh22";

  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = https://ocaml.janestreet.com/;
    description = "Library for serializing OCaml values to and from S-expressions";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
