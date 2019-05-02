{ stdenv, intltool, fetchurl, python3
, pkgconfig, gtk3, glib, gobject-introspection
, wrapGAppsHook, itstool, libxml2, docbook_xsl
, gnome3, gdk_pixbuf, libxslt, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "glade-${version}";
  version = "3.22.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glade/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "16p38xavpid51qfy0s26n0n21f9ws1w9k5s65bzh1w7ay8p9my6z";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "glade"; attrPath = "gnome3.glade"; };
  };

  nativeBuildInputs = [
    pkgconfig intltool itstool wrapGAppsHook docbook_xsl libxslt gobject-introspection
  ];
  buildInputs = [
    gtk3 glib libxml2 python3 python3.pkgs.pygobject3
    gsettings-desktop-schemas
    gdk_pixbuf gnome3.adwaita-icon-theme
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Glade;
    description = "User interface designer for GTK+ applications";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
