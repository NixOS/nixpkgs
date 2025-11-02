{
  stdenv,
  lib,
  fetchurl,
  automake,
  ocaml,
  autoconf,
  gnum4,
  pkg-config,
  freetype,
  lablgtk,
  unzip,
  cairo,
  findlib,
  gdk-pixbuf,
  gtk2,
  pango,
}:

let
  pname = "ocaml-cairo";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "http://cgit.freedesktop.org/cairo-ocaml/snapshot/cairo-ocaml-${version}.zip";
    sha256 = "0l4p9bp6kclr570mxma8wafibr1g5fsjj8h10yr4b507g0hmlh0l";
  };

  patches = [ ./META.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    unzip
    ocaml
    automake
    gnum4
    autoconf
    findlib
  ];
  buildInputs = [
    freetype
    lablgtk
    cairo
    gdk-pixbuf
    gtk2
    pango
  ];

  createFindlibDestdir = true;

  preConfigure = ''
    aclocal -I support
    autoconf
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE `pkg-config --cflags cairo gdk-pixbuf glib gtk+ pango`"
    export LABLGTKDIR=${lablgtk}/lib/ocaml/${ocaml.version}/site-lib/lablgtk2
    cp ${lablgtk}/lib/ocaml/${ocaml.version}/site-lib/lablgtk2/pango.ml ./src
    cp ${lablgtk}/lib/ocaml/${ocaml.version}/site-lib/lablgtk2/gaux.ml ./src
  '';

  postInstall = ''
    cp META $out/lib/ocaml/${ocaml.version}/site-lib/cairo/
  '';

  makeFlags = [ "INSTALLDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib/cairo" ];

  meta = {
    homepage = "http://cairographics.org/cairo-ocaml";
    description = "Ocaml bindings for cairo library";
    license = lib.licenses.gpl2;
    broken = lib.versionAtLeast ocaml.version "4.06";
    inherit (ocaml.meta) platforms;
  };
}
