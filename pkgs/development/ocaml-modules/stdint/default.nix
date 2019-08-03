{ stdenv, fetchFromGitHub, ocaml, findlib, dune }:

stdenv.mkDerivation rec {
  pname = "stdint";
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "0.5.1";
  src = fetchFromGitHub {
    owner = "andrenth";
    repo = "ocaml-stdint";
    rev = version;
    sha256 = "0z2z77m3clna9m9k0f8fd1400cdlglvy1kr893qs3907b3v0c057";
  };

  buildInputs = [ ocaml findlib dune ];

  buildPhase = "dune build -p ${pname}";
  inherit (dune) installPhase;

  meta = {
    description = "Various signed and unsigned integers for OCaml";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.gebner ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
