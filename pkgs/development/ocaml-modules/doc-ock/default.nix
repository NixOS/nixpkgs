{ stdenv, fetchFromGitHub, ocaml, findlib, dune, octavius, cppo }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-doc-ock-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = "doc-ock";
    rev = "v${version}";
    sha256 = "090vprm12jrl55yllk1hdzbsqyr107yjs2qnc49yahdhvnr4h5b7";
  };

  buildInputs = [ ocaml findlib dune cppo ];

  propagatedBuildInputs = [ octavius ];

  inherit (dune) installPhase;

  meta = {
    description = "Extract documentation from OCaml files";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
