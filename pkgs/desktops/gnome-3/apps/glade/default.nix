{ stdenv, intltool, fetchurl, python, autoreconfHook
, pkgconfig, gtk3, glib
, makeWrapper, itstool, libxml2, docbook_xsl
, gnome3, librsvg, gdk_pixbuf, libxslt }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [
    pkgconfig intltool itstool makeWrapper docbook_xsl libxslt
    # reconfiguration
    autoreconfHook gnome3.gnome_common gnome3.yelp_tools
  ];
  buildInputs = [ gtk3 glib libxml2 python
                  gnome3.gsettings_desktop_schemas
                  gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  enableParallelBuilding = true;

  patches = [
    # https://bugzilla.gnome.org/show_bug.cgi?id=782161
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=351054;
      sha256 = "093wjjj40027pkqqnm14jb2dp2i2m8p1bayqx1lw18pq66c8fahn";
    })
  ];

  preFixup = ''
    wrapProgram "$out/bin/glade" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Glade;
    description = "User interface designer for GTK+ applications";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
