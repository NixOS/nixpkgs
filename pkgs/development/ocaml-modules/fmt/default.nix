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

if lib.versionOlder ocaml.version "4.08" then
  throw "fmt is not available for OCaml ${ocaml.version}"
else

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

    meta = {
      homepage = "https://erratique.ch/software/fmt";
      license = lib.licenses.isc;
      description = "OCaml Format pretty-printer combinators";
      inherit (ocaml.meta) platforms;
      maintainers = [ lib.maintainers.vbgl ];
    };
  }
