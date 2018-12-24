{ stdenv, fetchurl, pkgconfig, mono
, glib
, pango
, gtk2
, GConf ? null
, libglade ? null
, libgtkhtml ? null
, gtkhtml ? null
, libgnomecanvas ? null
, libgnomeui ? null
, libgnomeprint ? null
, libgnomeprintui ? null
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

  postInstall = ''
    pushd $out/bin
    for f in gapi2-*
    do
      substituteInPlace $f --replace mono ${mono}/bin/mono
    done
    popd
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    mono glib pango gtk2 GConf libglade libgnomecanvas
    libgtkhtml libgnomeui libgnomeprint libgnomeprintui gtkhtml libxml2
  ];

  dontStrip = true;

  inherit monoDLLFixer;

  passthru = {
    gtk = gtk2;
  };

  meta = with stdenv.lib; {
    description = "Graphical User Interface Toolkit for mono and .Net";
    homepage = https://www.mono-project.com/docs/gui/gtksharp;
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
