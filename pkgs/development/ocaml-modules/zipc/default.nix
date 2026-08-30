{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  cmdliner,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-zipc";
  version = "0.2.0";

  src = fetchurl {
    url = "https://erratique.ch/software/zipc/releases/zipc-${version}.tbz";
    hash = "sha256-YQqkCURwrJgFH0+zgfket25zJQ4w+Tcc1mTSrDuWRt0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
  ];

  buildInputs = [
    cmdliner
    topkg
  ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "ZIP archive and deflate codec for OCaml";
    homepage = "https://erratique.ch/software/zipc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    broken = !(lib.versionAtLeast ocaml.version "4.14");
  };
}
