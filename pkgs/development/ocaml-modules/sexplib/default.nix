{stdenv, fetchurl, ocaml, findlib, ocaml_typeconv}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionOlder "4.00" ocaml_version;

stdenv.mkDerivation {
  name = "ocaml-sexplib-111.25.0";

  src = fetchurl {
    url = https://ocaml.janestreet.com/ocaml-core/111.25.00/individual/sexplib-111.25.00.tar.gz;
    sha256 = "0qh0zqp5nakqpmmhh4x7cg03vqj3j2bj4zj0nqdlksai188p9ila";
  };

  buildInputs = [ocaml findlib ocaml_typeconv ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://ocaml.janestreet.com/;
    description = "Library for serializing OCaml values to and from S-expressions";
    license = stdenv.lib.licenses.asl20;
    platforms = ocaml.meta.platforms;
  };
}
