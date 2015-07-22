{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, makeWrapper
, intltool, itstool, clutter, clutter_gtk, libxml2 }:

stdenv.mkDerivation rec {
  name = "lightsoff-${gnome3.version}.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${gnome3.version}/${name}.tar.xz";
    sha256 = "00a2jv7wr6fxrzk7avwa0wspz429ad7ri7v95jv31nqn5q73y4c0";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  libxml2 clutter clutter_gtk makeWrapper itstool intltool ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/lightsoff" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Lightsoff;
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
