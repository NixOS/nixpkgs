{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, makeWrapper
, intltool, itstool, libcanberra_gtk3, libxml2 }:

stdenv.mkDerivation rec {
  name = "iagno-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${gnome3.version}/${name}.tar.xz";
    sha256 = "0pg4sx277idfab3qxxn8c7r6gpdsdw5br0x7fxhxqascvvx8my1k";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  libxml2 libcanberra_gtk3 makeWrapper itstool intltool ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/iagno" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Iagno;
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
