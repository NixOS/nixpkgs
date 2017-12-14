{ stdenv, intltool, fetchurl, python
, pkgconfig, gtk3, glib, gobjectIntrospection
, wrapGAppsHook, itstool, libxml2, docbook_xsl
, gnome3, gdk_pixbuf, libxslt }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [
    pkgconfig intltool itstool wrapGAppsHook docbook_xsl libxslt gobjectIntrospection
  ];
  buildInputs = [ gtk3 glib libxml2 python
                  gnome3.gsettings_desktop_schemas
                  gdk_pixbuf gnome3.defaultIconTheme ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Glade;
    description = "User interface designer for GTK+ applications";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
