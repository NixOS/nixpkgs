{ stdenv, fetchgit, ocaml, findlib, ocamlbuild, js_of_ocaml, js_of_ocaml-camlp4, camlp4, lwt3, react }:

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "ojquery is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.1";
  name = "ocaml-ojquery-${version}";
  src = fetchgit {
    url = https://github.com/ocsigen/ojquery.git;
    rev = "refs/tags/${version}";
    sha256 = "1n01bsk4car40p94fk1ssvww0inqapwwhdylmrb7vv40drsdldp1";
  };

  buildInputs = [ ocaml findlib ocamlbuild js_of_ocaml-camlp4 camlp4 ];
  propagatedBuildInputs = [ js_of_ocaml lwt3 react ];

  createFindlibDestdir = true;

  meta = {
    description = "jQuery Binding for Eliom";
    homepage = http://ocsigen.org/ojquery/;
    license = stdenv.lib.licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
