{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  astring,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-fpath";
  version = "0.7.3";

  src = fetchurl {
    url = "https://erratique.ch/software/fpath/releases/fpath-${version}.tbz";
    hash = "sha256-ErCP8ZLQN9m21p6coZ0dOFGE8gsyN8JyMeQ3rIGs5w8=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];

  propagatedBuildInputs = [ astring ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "OCaml module for handling file system paths with POSIX and Windows conventions";
    homepage = "https://erratique.ch/software/fpath";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder ocaml.version "4.03";
  };
}
