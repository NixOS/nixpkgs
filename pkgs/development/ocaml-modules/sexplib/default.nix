{stdenv, fetchurl, ocaml, findlib, ocaml_typeconv}:

stdenv.mkDerivation {
  name = "ocaml-sexplib-7.0.5";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/832/sexplib-7.0.5.tar.gz";
    sha256 = "b1022da052254581aae51fb634345920364439f715a2c786abcd0b828c2ce697";
  };

  patches = [ ./sexp-3.10-compat.patch ];
  buildInputs = [ocaml findlib ocaml_typeconv ];

  createFindlibDestdir = true;

  meta = {
    homepage = "http://forge.ocamlcore.org/projects/sexplib/";
    description = "Library for serializing OCaml values to and from S-expressions.";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
  };
}
