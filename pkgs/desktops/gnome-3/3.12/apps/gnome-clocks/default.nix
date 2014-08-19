{ stdenv, intltool, fetchurl, libgweather, libnotify
, pkgconfig, gtk3, glib, hicolor_icon_theme
, makeWrapper, itstool, libcanberra_gtk3, libtool
, gnome3, librsvg, gdk_pixbuf, geoclue2 }:

stdenv.mkDerivation rec {
  name = "gnome-clocks-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/3.12/${name}.tar.xz";
    sha256 = "3fc0ce2b7b2540d6c2d791ff63ab1670f189a339c804fcf24c9010a478314604";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas makeWrapper
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg
                  gnome3.gnome_desktop gnome3.geocode_glib geoclue2
                  libgweather libnotify libtool
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/gnome-clocks" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
