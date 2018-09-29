{ stdenv, fetchFromGitHub, ocaml, findlib, dune
, bos, cmdliner, doc-ock-html, doc-ock-xml
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-odoc-${version}";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "odoc";
    rev = "v${version}";
    sha256 = "0ixnhfpm1nw4bvjj8qhcyy283pdr5acqpg5wxwq3n1l4mad79cgh";
  };

  buildInputs = [ ocaml findlib dune cmdliner ];

  propagatedBuildInputs = [ bos doc-ock-html doc-ock-xml ];

  inherit (dune) installPhase;

  meta = {
    description = "A documentation generator for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
