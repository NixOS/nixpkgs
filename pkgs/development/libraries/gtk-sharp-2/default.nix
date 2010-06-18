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
  name = "gtk-sharp-2.12.9";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnome.org/pub/gnome/sources/gtk-sharp/2.12/gtk-sharp-2.12.9.tar.gz;
    sha256 = "1wh8zh960s4gq3cs11ys6p1ssblhpj2m8nm4xwv2s3bi7wbmcclh";
  };

  # patches = [ ./dllmap-glue.patch ];

  buildInputs = [
    pkgconfig mono glib pango gtk GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
    gnomepanel
  ];

  inherit monoDLLFixer;
}
