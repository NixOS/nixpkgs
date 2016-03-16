{ stdenv, fetchurl, ocaml, findlib, opam, gg, uutf, otfm, js_of_ocaml,
  pdfBackend ? true, # depends on uutf and otfm
  htmlcBackend ? true # depends on js_of_ocaml
}:

let
  inherit (stdenv.lib) getVersion optionals versionAtLeast;

  pname = "vg";
  version = "0.8.1";
  webpage = "http://erratique.ch/software/${pname}";
in

assert versionAtLeast (getVersion ocaml) "4.01.0";

stdenv.mkDerivation rec {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1cdcvsr5z8845ndilnrz7p4n6yn4gv2p91z2mgi4vrailcmn5vzd";
  };

  buildInputs = [ ocaml findlib opam ];

  propagatedBuildInputs = [ gg ]
                          ++ optionals pdfBackend [ uutf otfm ]
                          ++ optionals htmlcBackend [ js_of_ocaml ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true"
               + (if pdfBackend then " uutf=true otfm=true"
                                else " uutf=false otfm=false")
               + (if htmlcBackend then " jsoo=true"
                                  else " jsoo=false");

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install | sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${getVersion ocaml}/site-lib/${pname}
  '';

  meta = with stdenv.lib; {
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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
