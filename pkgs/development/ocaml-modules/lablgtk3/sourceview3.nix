{ stdenv, ocaml, gtksourceview, lablgtk3 }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-lablgtk3-sourceview3-${version}";
  buildPhase = "dune build -p lablgtk3-sourceview3";
  buildInputs = lablgtk3.buildInputs ++ [ gtksourceview ];
  propagatedBuildInputs = [ lablgtk3 ];
  inherit (lablgtk3) src version meta nativeBuildInputs installPhase;
}
