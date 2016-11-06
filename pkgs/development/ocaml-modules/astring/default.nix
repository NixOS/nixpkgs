{stdenv, fetchurl, buildOcaml, ocaml, findlib, ocamlbuild, topkg, opam}:

buildOcaml rec {
  version = "0.8.3";
  name = "astring";

  src = fetchurl {
    url = "http://erratique.ch/software/astring/releases/astring-${version}.tbz";
    sha256 = "0ixjwc3plrljvj24za3l9gy0w30lsbggp8yh02lwrzw61ls4cri0";
  };

  unpackCmd = "tar -xf $curSrc";

  buildInputs = [ ocaml findlib ocamlbuild topkg opam ];

  buildPhase = ''
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ pkg/pkg.ml build
  '';

  installPhase = ''
    opam-installer --script --prefix=$out astring.install | sh
    ln -s $out/lib/astring $out/lib/ocaml/${ocaml.version}/site-lib/
  '';

  meta = {
    homepage = http://erratique.ch/software/astring;
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
