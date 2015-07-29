{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, makeWrapper
, clutter, clutter_gtk, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "swell-foop-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/swell-foop/${gnome3.version}/${name}.tar.xz";
    sha256 = "0bhjmjcjsqdb89shs0ygi6ps5hb3lk8nhrbjnsjk4clfqbw0jzwf";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  makeWrapper itstool intltool clutter clutter_gtk libxml2 ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/swell-foop" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Swell%20Foop";
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
