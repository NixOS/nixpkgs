{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg
, uchar, result, gg, uutf, otfm
, js_of_ocaml, js_of_ocaml-ppx,
  pdfBackend ? true, # depends on uutf and otfm
  htmlcBackend ? true # depends on js_of_ocaml
}:

let
  inherit (lib) optionals versionOlder;

  pname = "vg";
  version = "0.9.4";
  webpage = "https://erratique.ch/software/${pname}";
in

if versionOlder ocaml.version "4.03"
then throw "vg is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "181sz6l5xrj5jvwg4m2yqsjzwp2s5h8v0mwhjcwbam90kdfx2nak";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ topkg ];

  propagatedBuildInputs = [ uchar result gg ]
                          ++ optionals pdfBackend [ uutf otfm ]
                          ++ optionals htmlcBackend [ js_of_ocaml js_of_ocaml-ppx ];

  strictDeps = true;

  buildPhase = topkg.buildPhase
    + " --with-uutf ${lib.boolToString pdfBackend}"
    + " --with-otfm ${lib.boolToString pdfBackend}"
    + " --with-js_of_ocaml ${lib.boolToString htmlcBackend}"
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
  };
}
