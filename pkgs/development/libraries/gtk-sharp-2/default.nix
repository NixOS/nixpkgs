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
  name = "gtk-sharp-2.12.10";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://gnome/sources/gtk-sharp/2.12/gtk-sharp-2.12.10.tar.gz;
    sha256 = "1y55vc2cp4lggmbil2lb28d0gn71iq6wfyja1l9mya5xll8svzwc";
  };

  # patches = [ ./dllmap-glue.patch ];

  # patch bad usage of glib, which wasn't tolerated anymore
  prePatch = ''
    for f in glib/glue/{thread,list,slist}.c; do
      sed -i 's,#include <glib/.*\.h>,#include <glib.h>,g' "$f"
    done
  '';

  buildInputs = [
    pkgconfig mono glib pango gtk GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
    gnomepanel
  ];

  dontStrip = true;

  inherit monoDLLFixer;

  passthru = {
    inherit gtk;
  };
}
