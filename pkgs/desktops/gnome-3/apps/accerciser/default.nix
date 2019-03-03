{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gobject-introspection
, itstool, libxml2, python3Packages, at-spi2-core
, dbus, intltool, libwnck3 }:

stdenv.mkDerivation rec {
  name = "accerciser-${version}";
  version = "3.31.4";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "17x0c08k483vnpixkg547xildlpv649bv4z2qc3m97xhikbbb2a8";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook itstool intltool
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
