{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg }:

stdenv.mkDerivation rec {
  version = "0.8.3";
  name = "ocaml${ocaml.version}-astring-${version}";

  src = fetchurl {
    url = "http://erratique.ch/software/astring/releases/astring-${version}.tbz";
    sha256 = "0ixjwc3plrljvj24za3l9gy0w30lsbggp8yh02lwrzw61ls4cri0";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = https://erratique.ch/software/astring;
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
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
