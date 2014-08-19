{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, hicolor_icon_theme, gnome3, gdk_pixbuf
, bash, makeWrapper, itstool, libxml2, libxslt, icu }:

stdenv.mkDerivation rec {
  name = "yelp-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/3.10/${name}.tar.xz";
    sha256 = "17736479b7d0b1128c7d6cb3073f2b09e4bbc82670731b2a0d3a3219a520f816";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard  ];
  propagatedBuildInputs = [ librsvg gdk_pixbuf gnome3.gnome_icon_theme
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool
                  libxml2 libxslt icu file makeWrapper gnome3.yelp_xsl
                  gnome3.gsettings_desktop_schemas ];

  preFixup = ''
    wrapProgram "$out/bin/yelp" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/:${gnome3.gnome_themes_standard}/share:${gnome3.yelp_xsl}/share/yelp-xsl:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/yelp:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp is the help viewer in Gnome.";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
