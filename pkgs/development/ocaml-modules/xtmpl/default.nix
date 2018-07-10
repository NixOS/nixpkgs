{ stdenv, fetchFromGitLab, ocaml, findlib, iri, ppx_tools, js_of_ocaml
, js_of_ocaml-ppx, re }:

if stdenv.lib.versionOlder ocaml.version "4.03"
then throw "xtmpl not supported for ocaml ${ocaml.version}"
else
stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-xtmpl-${version}";
  version = "0.17.0";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "xtmpl";
    rev = version;
    sha256 = "1hq6y4rhz958q40145k4av8hx8jyvspg78xf741samd7vc3jd221";
  };

  buildInputs = [ ocaml findlib ppx_tools js_of_ocaml js_of_ocaml-ppx ];
  propagatedBuildInputs = [ iri re ];

  createFindlibDestdir = true;

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "XML templating library for OCaml";
    homepage = "https://www.good-eris.net/xtmpl/";
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ regnat ];
  };
}
