{ stdenv, fetchurl, pkgconfig, mono
, glib
, pango
, gtk3
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
  name = "gtk-sharp-2.99.3";

  builder = ./builder.sh;
  src = fetchurl {
    #"mirror://gnome/sources/gtk-sharp/2.99/gtk-sharp-2.99.3.tar.xz";
    url = "http://ftp.gnome.org/pub/GNOME/sources/gtk-sharp/2.99/gtk-sharp-2.99.3.tar.xz";
    sha256 = "18n3l9zcldyvn4lwi8izd62307mkhz873039nl6awrv285qzah34";
  };

  # patch bad usage of glib, which wasn't tolerated anymore
  # prePatch = ''
  #   for f in glib/glue/{thread,list,slist}.c; do
  #     sed -i 's,#include <glib/.*\.h>,#include <glib.h>,g' "$f"
  #   done
  # '';

  buildInputs = [
    pkgconfig mono glib pango gtk3 GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
    gnomepanel
  ];

  dontStrip = true;

  inherit monoDLLFixer;

  passthru = {
    inherit gtk3;
  };
}
