{ stdenv, fetchFromGitHub, ocaml, findlib, dune, alcotest }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "faraday is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-faraday-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "faraday";
    rev = version;
    sha256 = "1kql0il1frsbx6rvwqd7ahi4m14ik6la5an6c2w4x7k00ndm4d7n";
  };

  buildInputs = [ ocaml findlib dune alcotest ];

  buildPhase = "dune build -p faraday";

  doCheck = true;
  checkPhase = "jbuilder runtest";

  inherit (dune) installPhase;

  meta = {
    description = "Serialization library built for speed and memory efficiency";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
