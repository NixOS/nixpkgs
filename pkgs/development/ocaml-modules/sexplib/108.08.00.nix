{stdenv, fetchurl, ocaml, findlib, typeconv}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

assert stdenv.lib.versionOlder "3.12" ocaml_version;

stdenv.mkDerivation {
  name = "ocaml-sexplib-108.08.00";

  src = fetchurl {
    url = https://ocaml.janestreet.com/ocaml-core/108.08.00/individual/sexplib-108.08.00.tar.gz;
    sha256 = "11z1k1d7dbb5m957klgalimpr0r602xp5zkkbgbffib1bphasarg";
  };

  buildInputs = [ocaml findlib typeconv ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://ocaml.janestreet.com/;
    description = "Library for serializing OCaml values to and from S-expressions";
    license = stdenv.lib.licenses.asl20;
    platforms = ocaml.meta.platforms;
  };
}
