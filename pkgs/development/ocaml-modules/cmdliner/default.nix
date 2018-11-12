{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, result }:

let
  pname = "cmdliner";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01.0";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "http://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "18jqphjiifljlh9jg8zpl6310p3iwyaqphdkmf89acyaix0s4kj1";
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
