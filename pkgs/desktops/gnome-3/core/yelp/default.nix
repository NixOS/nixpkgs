{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, hicolor_icon_theme, gnome3, gdk_pixbuf
, bash, makeWrapper, itstool, libxml2, libxslt, icu  }:

stdenv.mkDerivation rec {
  name = "yelp-3.10.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/yelp/3.10/${name}.tar.xz";
    sha256 = "17736479b7d0b1128c7d6cb3073f2b09e4bbc82670731b2a0d3a3219a520f816";
  };

  propagatedUserEnvPkgs = [ librsvg gdk_pixbuf gnome3.gnome_themes_standard
                            gnome3.gnome_icon_theme hicolor_icon_theme
                            gnome3.gnome_icon_theme_symbolic ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool
                  libxml2 libxslt icu file makeWrapper gnome3.yelp_xsl
                  gnome3.gsettings_desktop_schemas ];

  installFlags = "gsettingsschemadir=\${out}/share/${name}/glib-2.0/schemas/";

  postInstall = ''
    mkdir -p $out/lib/yelp/gdk-pixbuf-2.0/2.10.0
    cat ${gdk_pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache ${librsvg}/lib/gdk-pixbuf/loaders.cache > $out/lib/yelp/gdk-pixbuf-2.0/2.10.0/loaders.cache
    wrapProgram "$out/bin/yelp" \
      --set GDK_PIXBUF_MODULE_FILE `readlink -e $out/lib/yelp/gdk-pixbuf-2.0/2.10.0/loaders.cache` \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/:${gnome3.gnome_themes_standard}/share:${gnome3.gnome_icon_theme_symbolic}/share:${gnome3.yelp_xsl}/share/yelp-xsl:${gnome3.gnome_icon_theme}/share:${hicolor_icon_theme}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/${name}"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp is the help viewer in Gnome.";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
