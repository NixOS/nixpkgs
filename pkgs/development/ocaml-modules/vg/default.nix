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

  pname = "vg";
  version = "0.9.5";
  webpage = "https://erratique.ch/software/${pname}";
in
stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
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

  meta = with lib; {
    description = "Declarative 2D vector graphics for OCaml";
    longDescription = ''
      Vg is an OCaml module for declarative 2D vector graphics. In Vg, images
      are values that denote functions mapping points of the cartesian plane
      to colors. The module provides combinators to define and compose these
      values.

      Renderers for PDF, SVG and the HTML canvas are distributed with the
      module. An API allows to implement new renderers.
    '';
    homepage = webpage;
    license = licenses.isc;
    maintainers = [ maintainers.jirkamarsik ];
    mainProgram = "vecho";
    inherit (ocaml.meta) platforms;
    broken = versionOlder ocaml.version "4.14";
  };
}
