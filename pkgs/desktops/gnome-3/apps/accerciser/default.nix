{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gobject-introspection
, itstool, libxml2, python3Packages, at-spi2-core
, dbus, gettext, libwnck3 }:

stdenv.mkDerivation rec {
  name = "accerciser-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1j7wlks6j77kfjrw6lx1g0apsy2wwca63jsm5994av5l6xs8xd5m";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook itstool gettext
    gobject-introspection # For setup hook
  ];
  buildInputs = [
    gtk3 libxml2 python3Packages.python python3Packages.pyatspi
    python3Packages.pygobject3 python3Packages.ipython
    at-spi2-core dbus libwnck3 gnome3.adwaita-icon-theme
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "accerciser";
      attrPath = "gnome3.accerciser";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Accerciser;
    description = "Interactive Python accessibility explorer";
    maintainers = gnome3.maintainers;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
