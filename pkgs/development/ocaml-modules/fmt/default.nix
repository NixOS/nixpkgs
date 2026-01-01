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
  version = "0.11.0";
  pname = "ocaml${ocaml.version}-fmt";

  src = fetchurl {
    url = "https://erratique.ch/software/fmt/releases/fmt-${version}.tbz";
    sha256 = "sha256-hXz9R6VLUkKc2bPiZl5EFzzRvTtDW+znFy+YStU3ahs=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [
    cmdliner
    topkg
  ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

<<<<<<< HEAD
  meta = {
    homepage = "https://erratique.ch/software/fmt";
    license = lib.licenses.isc;
    description = "OCaml Format pretty-printer combinators";
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
=======
  meta = with lib; {
    homepage = "https://erratique.ch/software/fmt";
    license = licenses.isc;
    description = "OCaml Format pretty-printer combinators";
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = lib.versionOlder ocaml.version "4.08";
  };
}
