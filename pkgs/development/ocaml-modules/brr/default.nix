{ stdenv, lib, fetchurl
, ocaml, findlib, ocamlbuild, topkg
, js_of_ocaml-compiler
, js_of_ocaml-toplevel
, note
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-brr";
  version = "0.0.4";
  src = fetchurl {
    url = "https://erratique.ch/software/brr/releases/brr-${version}.tbz";
    hash = "sha256-v+Ik1tdRBVnNDqhmNoJuLelL3k5OhxIsUorGdTb9sbw=";
  };
  buildInputs = [ ocaml findlib ocamlbuild topkg ];
  propagatedBuildInputs = [ js_of_ocaml-compiler js_of_ocaml-toplevel note ];
  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = "https://erratique.ch/software/brr";
    description = "A toolkit for programming browsers in OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
