{ stdenv, intltool, fetchurl, vala, libgtop
, pkgconfig, gtk3, glib
, bash, makeWrapper, itstool, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ vala pkgconfig gtk3 glib libgtop intltool itstool libxml2
                  gnome3.gsettings_desktop_schemas makeWrapper file
                  gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  preFixup = ''
    wrapProgram "$out/bin/baobab" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Baobab;
    description = "Graphical application to analyse disk usage in any Gnome environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
