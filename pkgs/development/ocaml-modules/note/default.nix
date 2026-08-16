{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  brr,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-note";
  version = "0.0.3";
  src = fetchurl {
    url = "https://erratique.ch/software/note/releases/note-${version}.tbz";
    hash = "sha256-ZZOvCnyz7UWzFtGFI1uC0ZApzyylgZYM/HYIXGVXY2k=";
  };
  buildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  inherit (topkg) buildPhase installPhase;

  propagatedBuildInputs = [ brr ];

  meta = {
    homepage = "https://erratique.ch/software/note";
    description = "OCaml module for functional reactive programming";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    broken = !(lib.versionAtLeast ocaml.version "4.08");
  };
}
