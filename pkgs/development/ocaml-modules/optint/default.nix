{ stdenv, fetchurl, ocaml, findlib, dune }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "optint is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.0.2";
  name = "ocaml${ocaml.version}-optint-${version}";
  src = fetchurl {
    url = "https://github.com/mirage/optint/releases/download/v0.0.2/optint-v0.0.2.tbz";
    sha256 = "1lmb7nycmkr05y93slqi98i1lcs1w4kcngjzjwz7i230qqjpw9w1";
  };

  buildInputs = [ ocaml findlib dune ];

  buildPhase = "dune build";

  inherit (dune) installPhase;

  meta = {
    homepage = "https://github.com/mirage/optint";
    description = "Abstract type of integer between x64 and x86 architecture";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
