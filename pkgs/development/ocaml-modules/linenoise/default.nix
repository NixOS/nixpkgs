{ stdenv, fetchFromGitHub, ocaml, dune, findlib, result }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "linenoise is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-linenoise-${version}";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "fxfactorial";
    repo = "ocaml-linenoise";
    rev = "v${version}";
    sha256 = "1h6rqfgmhmd7p5z8yhk6zkbrk4yzw1v2fgwas2b7g3hqs6y0xj0q";
  };

  buildInputs = [ ocaml findlib dune ];
  propagatedBuildInputs = [ result ];

  inherit (dune) installPhase;

  meta = {
    description = "OCaml bindings to linenoise";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
