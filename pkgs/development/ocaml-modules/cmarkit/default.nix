{
  lib,
  stdenv,
  cmdliner,
  fetchurl,
  findlib,
  ocaml,
  ocamlbuild,
  topkg,
}:

stdenv.mkDerivation rec {
  pname = "cmarkit";
  version = "0.4.0";

  src = fetchurl {
    url = "https://erratique.ch/software/cmarkit/releases/cmarkit-${version}.tbz";
    hash = "sha256-15C1aYXp5JBXUeb1KatPXphs/iBHXSiZ2tgO8FVf/jc=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];

  buildInputs = [
    topkg
    cmdliner
  ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "CommonMark parser and renderer for OCaml";
    homepage = "https://erratique.ch/software/cmarkit";
    changelog = "https://github.com/dbuenzli/cmarkit/blob/v${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ ];
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder ocaml.version "4.14.0";
  };
}
