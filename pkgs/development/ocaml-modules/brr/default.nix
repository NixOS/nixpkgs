{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  js_of_ocaml-compiler,
  js_of_ocaml-toplevel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-brr";
  version = "0.1.0";
  src = fetchurl {
    url = "https://erratique.ch/software/brr/releases/brr-${finalAttrs.version}.tbz";
    hash = "sha256-hch4Qy3nUjA78U5tPs85zJNKId02SgspFhYXIdKMIOA=";
  };
  buildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  propagatedBuildInputs = [
    js_of_ocaml-compiler
    js_of_ocaml-toplevel
  ];
  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = "https://erratique.ch/software/brr";
    description = "Toolkit for programming browsers in OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder js_of_ocaml-compiler.version "6.5.0";
  };
})
