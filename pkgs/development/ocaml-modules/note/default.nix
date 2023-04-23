{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "note is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-note";
  version = "0.0.2";
  src = fetchurl {
    url = "https://erratique.ch/software/note/releases/note-${version}.tbz";
    hash = "sha256-b35XcaDUXQLqwkNfsJKX5A1q1pAhw/mgdwyOdacZiiY=";
  };
  buildInputs = [ ocaml findlib ocamlbuild topkg ];
  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = "https://erratique.ch/software/note";
    description = "An OCaml module for functional reactive programming";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
