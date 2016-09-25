{ stdenv, fetchgit, ocaml, findlib, ocplib-endian, uri }:

let version = "0.4"; in

stdenv.mkDerivation {
  name = "ocaml-ocplib-json-typed-${version}";

  src = fetchgit {
    url = "https://github.com/OCamlPro/ocplib-json-typed.git";
    rev = "09225b02e0cb9cb16868acc7c35ae1b4fc6daafb";
    sha256 = "0nk68qzl953pkahvg92xshn9ax218sd5fz8rxb3nwa1qsjd0dimz";
  };

  buildInputs = [ ocaml findlib ocplib-endian uri];

  createFindlibDestdir = true;

  meta = {
    description = "Libraries for reliable manipulation JSON objects";
    homepage = https://github.com/OCamlPro/ocplib-json-typed;
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
