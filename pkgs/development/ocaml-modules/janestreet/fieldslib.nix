{ lib, type_conv, buildOcamlJane }:

buildOcamlJane {
  name = "fieldslib";
  version = "113.33.03";

  minimumSupportedOcamlVersion = "4.02";

  hash = "0mkbix32f8sq32q81hb10z2q31bw5f431jxv0jafbdrif0vr6xqd";

  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://ocaml.janestreet.com/";
    description = "OCaml syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.vbgl ];
  };
}
