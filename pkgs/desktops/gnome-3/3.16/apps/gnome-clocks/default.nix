{ stdenv, intltool, fetchurl, libgweather, libnotify
, pkgconfig, gtk3, glib, hicolor_icon_theme, gsound
, makeWrapper, itstool, libcanberra_gtk3, libtool
, gnome3, librsvg, gdk_pixbuf, geoclue2 }:

stdenv.mkDerivation rec {
  name = "gnome-clocks-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${gnome3.version}/${name}.tar.xz";
    sha256 = "1k7khghaq7y3j0r3kn9q7dwgi1875bfn4iy0sr1ls14m1p2bl10q";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas makeWrapper
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg
                  gnome3.gnome_desktop gnome3.geocode_glib geoclue2
                  libgweather libnotify libtool gsound
                  hicolor_icon_theme gnome3.adwaita-icon-theme ];

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/gnome-clocks" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
