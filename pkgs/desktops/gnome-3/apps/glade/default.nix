{ stdenv, intltool, fetchurl, python3
, pkgconfig, gtk3, glib, gobjectIntrospection
, wrapGAppsHook, itstool, libxml2, docbook_xsl
, gnome3, gdk_pixbuf, libxslt }:

stdenv.mkDerivation rec {
  name = "glade-${version}";
  version = "3.20.4";

  src = fetchurl {
    url = "mirror://gnome/sources/glade/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1n9m4s81jd9fi60mrxsvlk4fi2vqrqmp95azsxp9jnqn6pkdz0jb";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "glade"; attrPath = "gnome3.glade"; };
  };

  nativeBuildInputs = [
    pkgconfig intltool itstool wrapGAppsHook docbook_xsl libxslt gobjectIntrospection
  ];
  buildInputs = [
    gtk3 glib libxml2 python3 python3.pkgs.pygobject3
    gnome3.gsettings-desktop-schemas
    gdk_pixbuf gnome3.defaultIconTheme
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
