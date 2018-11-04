{ stdenv, fetchFromGitHub, ocaml, findlib, dune, cppo
, bos, cmdliner, tyxml
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-odoc-${version}";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "odoc";
    rev = version;
    sha256 = "0hjan5aj5zk8j8qyagv9r4hqm469mh207cv2m6kxwgnw0c3cz7sy";
  };

  buildInputs = [ ocaml findlib dune cppo bos cmdliner tyxml ];

  inherit (dune) installPhase;

  meta = {
    description = "A documentation generator for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
