{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, hicolor_icon_theme, gnome3, gdk_pixbuf, sqlite
, bash, makeWrapper, itstool, libxml2, libxslt, icu }:

stdenv.mkDerivation rec {
  name = "yelp-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${gnome3.version}/${name}.tar.xz";
    sha256 = "0az2f1g8gz341i93zxnm6sabrqx416a348ylwfr8vzlg592am2r3";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool sqlite
                  libxml2 libxslt icu file makeWrapper gnome3.yelp_xsl
                  librsvg gdk_pixbuf gnome3.adwaita-icon-theme
                  hicolor_icon_theme gnome3.adwaita-icon-theme
                  gnome3.gsettings_desktop_schemas ];

  preFixup = ''
    wrapProgram "$out/bin/yelp" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/:${gnome3.gnome_themes_standard}/share:${gnome3.yelp_xsl}/share/yelp-xsl:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/yelp:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "The help viewer in Gnome";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
