{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, result }:

let
  pname = "cmdliner";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01.0";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "http://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "0g3w4hvc1cx9x2yp5aqn6m2rl8lf9x1dn754hfq8m1sc1102lxna";
  };

  nativeBuildInputs = [ ocamlbuild topkg ];
  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ result ];

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    homepage = http://erratique.ch/software/cmdliner;
    description = "An OCaml module for the declarative definition of command line interfaces";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
  };
}
