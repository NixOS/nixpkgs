{ stdenv, lib, fetchurl
, ocaml, findlib, ocamlbuild, topkg
, js_of_ocaml-compiler
, js_of_ocaml-toplevel
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-brr";
  version = "0.0.7";
  src = fetchurl {
    url = "https://erratique.ch/software/brr/releases/brr-${version}.tbz";
    hash = "sha256-rcWuW6avI/RJZNAlxKOsPSEtDQZ1hb51oKpSk3iG7oY=";
  };
  buildInputs = [ ocaml findlib ocamlbuild topkg ];
  propagatedBuildInputs = [ js_of_ocaml-compiler js_of_ocaml-toplevel ];
  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = "https://erratique.ch/software/brr";
    description = "Toolkit for programming browsers in OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
