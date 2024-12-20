{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
}:

let
  # Use astring 0.8.3 for OCaml < 4.05
  param =
    if lib.versionAtLeast ocaml.version "4.05" then
      {
        version = "0.8.5";
        sha256 = "1ykhg9gd3iy7zsgyiy2p9b1wkpqg9irw5pvcqs3sphq71iir4ml6";
      }
    else
      {
        version = "0.8.3";
        sha256 = "0ixjwc3plrljvj24za3l9gy0w30lsbggp8yh02lwrzw61ls4cri0";
      };
in

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-astring";
  inherit (param) version;

  src = fetchurl {
    url = "https://erratique.ch/software/astring/releases/astring-${param.version}.tbz";
    inherit (param) sha256;
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
    homepage = "https://erratique.ch/software/astring";
    description = "Alternative String module for OCaml";
    longDescription = ''
      Astring exposes an alternative String module for OCaml. This module tries
      to balance minimality and expressiveness for basic, index-free, string
      processing and provides types and functions for substrings, string sets
      and string maps.

      Remaining compatible with the OCaml String module is a non-goal.
      The String module exposed by Astring has exception safe functions, removes
      deprecated and rarely used functions, alters some signatures and names,
      adds a few missing functions and fully exploits OCaml's newfound string
      immutability.
    '';
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
