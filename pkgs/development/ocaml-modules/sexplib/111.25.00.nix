{stdenv, fetchurl, ocaml, findlib, type_conv, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionOlder "4.00" ocaml_version;

stdenv.mkDerivation {
  name = "ocaml-sexplib-111.25.00";

  src = fetchurl {
    url = https://ocaml.janestreet.com/ocaml-core/111.25.00/individual/sexplib-111.25.00.tar.gz;
    sha256 = "0qh0zqp5nakqpmmhh4x7cg03vqj3j2bj4zj0nqdlksai188p9ila";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [type_conv camlp4];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://ocaml.janestreet.com/;
    description = "Library for serializing OCaml values to and from S-expressions";
    license = licenses.asl20;
    maintainers = [ maintainers.vbgl maintainers.ericbmerritt ];
    platforms = ocaml.meta.platforms;
  };
}
