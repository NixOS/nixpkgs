{ stdenv, fetchurl, pkgconfig, mono
, glib
, pango
, gtk
, GConf ? null
, libglade ? null
, libgtkhtml ? null
, gtkhtml ? null
, libgnomecanvas ? null
, libgnomeui ? null
, libgnomeprint ? null
, libgnomeprintui ? null
, gnomepanel ? null
, libxml2
, monoDLLFixer
}:

stdenv.mkDerivation {
  name = "gtk-sharp-1.9.2";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/gtk-sharp-1.9.2.tar.gz;
    md5 = "b7c5afab5f736ffa4011974302831363";
  };

  patches = [ ./dllmap-glue.patch ];

  buildInputs = [
    pkgconfig mono glib pango gtk GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
    gnomepanel
  ];

  inherit monoDLLFixer;
}
