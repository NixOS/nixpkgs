{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, ocb-stubblr }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-cpuid-0.1.0";

  src = fetchurl {
    url = https://github.com/pqwy/cpuid/releases/download/v0.1.0/cpuid-0.1.0.tbz;
    sha256 = "08k2558a3dnxn8msgpz8c93sfn0y027ganfdi2yvql0fp1ixv97p";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ocb-stubblr ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = https://github.com/pqwy/cpuid;
    description = "Detect CPU features from OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
