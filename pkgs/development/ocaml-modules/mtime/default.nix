{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-mtime";
  version = "2.2.0";

  src = fetchurl {
    url = "https://erratique.ch/software/mtime/releases/mtime-${finalAttrs.version}.tbz";
    hash = "sha256-+SEKB8Sj6xdWpF+ooyl02bXdrTWDw0AEQv3+LJ1j1jY=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "Monotonic wall-clock time for OCaml";
    homepage = "https://erratique.ch/software/mtime";
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.bsd3;
  };
})
