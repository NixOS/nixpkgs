{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, result }:

let
  pname = "cmdliner";
in

assert lib.versionAtLeast ocaml.version "4.01.0";

let param =
  if lib.versionAtLeast ocaml.version "4.03" then {
    version = "1.0.4";
    sha256 = "1h04q0zkasd0mw64ggh4y58lgzkhg6yhzy60lab8k8zq9ba96ajw";
  } else {
    version = "1.0.2";
    sha256 = "18jqphjiifljlh9jg8zpl6310p3iwyaqphdkmf89acyaix0s4kj1";
  }
; in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  inherit (param) version;

  src = fetchurl {
    url = "https://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    inherit (param) sha256;
  };

  nativeBuildInputs = [ ocaml ocamlbuild findlib topkg ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [ result ];

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = "https://erratique.ch/software/cmdliner";
    description = "An OCaml module for the declarative definition of command line interfaces";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
  };
}
