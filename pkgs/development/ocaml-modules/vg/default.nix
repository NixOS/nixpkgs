{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg
, uchar, result, gg, uutf, otfm
, js_of_ocaml, js_of_ocaml-ocamlbuild, js_of_ocaml-ppx,
  pdfBackend ? true, # depends on uutf and otfm
  htmlcBackend ? true # depends on js_of_ocaml
}:

with lib;

let
  inherit (stdenv.lib) optionals versionAtLeast;

  pname = "vg";
  version = "0.9.1";
  webpage = "https://erratique.ch/software/${pname}";
in

assert versionAtLeast ocaml.version "4.02.0";

stdenv.mkDerivation rec {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "07h9a464v0x066mjg3ldkaq94ah47b7rvh54z4rndrg7v6bk7kyp";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  propagatedBuildInputs = [ uchar result gg ]
                          ++ optionals pdfBackend [ uutf otfm ]
                          ++ optionals htmlcBackend [ js_of_ocaml js_of_ocaml-ocamlbuild js_of_ocaml-ppx ];

  buildPhase = topkg.buildPhase
    + " --with-uutf ${boolToString pdfBackend}"
    + " --with-otfm ${boolToString pdfBackend}"
    + " --with-js_of_ocaml ${boolToString htmlcBackend}"
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
    homepage = "${webpage}";
    inherit (ocaml.meta) platforms;
    license = licenses.isc;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
