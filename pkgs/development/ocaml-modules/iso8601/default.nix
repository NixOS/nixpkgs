{ stdenv, fetchzip, ocaml, findlib, ocamlbuild }:

let version = "0.2.4"; in

stdenv.mkDerivation {
  pname = "ocaml-iso8601";
  inherit version;
  src = fetchzip {
    url = "https://github.com/sagotch/ISO8601.ml/archive/${version}.tar.gz";
    sha256 = "0ypdd1p04xdjxxx3b61wp7abswfrq3vcvwwaxvywxwqljw0dhydi";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  createFindlibDestdir = true;

  meta = {
    homepage = "https://ocaml-community.github.io/ISO8601.ml/";
    description = "ISO 8601 and RFC 3999 date parsing for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
