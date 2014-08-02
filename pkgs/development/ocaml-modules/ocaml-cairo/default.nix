{stdenv, fetchurl, automake, ocaml, autoconf, gnum4, pkgconfig, freetype, lablgtk, unzip, cairo, findlib, gdk_pixbuf, glib, gtk, pango }: 

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "ocaml-cairo";
  version = "1.2.0";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl { 
    url = "http://cgit.freedesktop.org/cairo-ocaml/snapshot/cairo-ocaml-${version}.zip";
    sha256 = "2d59678e322c331e3f4bc02a77240fce4a0917acb0d3ae75953a6ac62d70a125";
  };

  patches = [ ./META.patch ];

  buildInputs = [ocaml automake gnum4 autoconf unzip pkgconfig findlib freetype lablgtk cairo gdk_pixbuf gtk pango ];

  createFindlibDestdir = true;

 preConfigure = ''
   aclocal -I support
   autoconf
   export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE `pkg-config --cflags cairo gdk-pixbuf glib  gtk+ pango`" 
   export LABLGTKDIR=${lablgtk}/lib/ocaml/${ocaml_version}/site-lib/lablgtk2
   cp ${lablgtk}/lib/ocaml/${ocaml_version}/site-lib/lablgtk2/pango.ml ./src
   cp ${lablgtk}/lib/ocaml/${ocaml_version}/site-lib/lablgtk2/gaux.ml ./src
  '';

  postInstall = ''
    cp META $out/lib/ocaml/${ocaml_version}/site-lib/cairo/
  '';

  makeFlags = "INSTALLDIR=$(out)/lib/ocaml/${ocaml_version}/site-lib/cairo";

  meta = {
    homepage = http://cairographics.org/cairo-ocaml;
    description = "ocaml bindings for cairo library";
    license = stdenv.lib.licenses.gpl2;
#    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
