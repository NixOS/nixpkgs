{ stdenv, fetchFromGitHub, ocaml, findlib, dune, doc-ock, menhir, xmlm }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-doc-ock-xml-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = "doc-ock-xml";
    rev = "v${version}";
    sha256 = "1s27ri7vj9ixi5p5ixg6g6invk96807bvxbqjrr1dm8sxgl1nd20";
  };

  buildInputs = [ ocaml findlib dune ];

  propagatedBuildInputs = [ doc-ock menhir xmlm ];

  inherit (dune) installPhase;

  meta = {
    description = "XML printer and parser for Doc-Ock";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
