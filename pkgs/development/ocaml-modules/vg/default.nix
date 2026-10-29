{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  uchar,
  result,
  gg,
  otfm,
  brr,
  pdfBackend ? true, # depends on otfm
  htmlcBackend ? true, # depends on brr
}:

let
  inherit (lib) optionals versionOlder;
in
stdenv.mkDerivation (finalAttrs: {
  name = "ocaml${ocaml.version}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "vg";
  version = "0.9.5";

  src = fetchurl {
    url = "https://erratique.ch/software/vg/releases/vg-${finalAttrs.version}.tbz";
    hash = "sha256-qcTtvIfSUwzpUZDspL+54UTNvWY6u3BTvfGWF6c0Jvw=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
  ];
  buildInputs = [ topkg ];

  propagatedBuildInputs = [
    uchar
    result
    gg
  ]
  ++ optionals pdfBackend [
    otfm
  ]
  ++ optionals htmlcBackend [
    brr
  ];

  strictDeps = true;

  buildPhase =
    topkg.buildPhase
    + " --with-otfm ${lib.boolToString pdfBackend}"
    + " --with-brr ${lib.boolToString htmlcBackend}"
    + " --with-cairo2 false";

  inherit (topkg) installPhase;

  meta = {
    description = "Declarative 2D vector graphics for OCaml";
    longDescription = ''
      Vg is an OCaml module for declarative 2D vector graphics. In Vg, images
      are values that denote functions mapping points of the cartesian plane
      to colors. The module provides combinators to define and compose these
      values.

      Renderers for PDF, SVG and the HTML canvas are distributed with the
      module. An API allows to implement new renderers.
    '';
    homepage = "https://erratique.ch/software/vg";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.jirkamarsik ];
    mainProgram = "vecho";
    inherit (ocaml.meta) platforms;
    broken = versionOlder ocaml.version "4.14";
  };
})
