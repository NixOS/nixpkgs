{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  cmdliner,
  topkg,
  uchar,
  version ?
    if lib.versionAtLeast ocaml.version "4.08" then
      "1.0.4"
    else if lib.versionAtLeast ocaml.version "4.03" then
      "1.0.3"
    else
      throw "uutf is not available with OCaml ${ocaml.version}",
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-uutf-${version}";
  inherit version;

  src = fetchurl {
    url = "https://erratique.ch/software/uutf/releases/uutf-${version}.tbz";
    hash =
      {
        "1.0.3" = "sha256-h3KlYT0ecCmM4U3zMkGjaF8h5O9r20zwP+mF+x7KBWg=";
        "1.0.4" = "sha256-p6V45q+RSaiJThjjtHWchWWTemnGyaznowu/BIRhnKg=";
      }
      ."${version}";
  };

  nativeBuildInputs = [
    ocaml
    ocamlbuild
    findlib
    topkg
  ];
  buildInputs = [
    topkg
    cmdliner
  ];
  propagatedBuildInputs = [ uchar ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "Non-blocking streaming Unicode codec for OCaml";
    homepage = "https://erratique.ch/software/uutf";
    changelog = "https://raw.githubusercontent.com/dbuenzli/uutf/refs/tags/v${version}/CHANGES.md";
    license = licenses.isc;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "utftrip";
    inherit (ocaml.meta) platforms;
  };
}
