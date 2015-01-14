{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, hicolor_icon_theme, gnome3, gdk_pixbuf, sqlite
, bash, makeWrapper, itstool, libxml2, libxslt, icu }:

stdenv.mkDerivation rec {
  name = "yelp-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/3.12/${name}.tar.xz";
    sha256 = "0k2a1fggidmh98x2fv8zki2lbx7wx7p4b25iq11p6q8j9fwr2ff8";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard  ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool
                  libxml2 libxslt icu file makeWrapper gnome3.yelp_xsl
                  librsvg gdk_pixbuf gnome3.gnome_icon_theme
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  gnome3.gsettings_desktop_schemas sqlite ];

  preFixup = ''
    wrapProgram "$out/bin/yelp" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/:${gnome3.gnome_themes_standard}/share:${gnome3.yelp_xsl}/share/yelp-xsl:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/yelp:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "The help viewer in Gnome";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
