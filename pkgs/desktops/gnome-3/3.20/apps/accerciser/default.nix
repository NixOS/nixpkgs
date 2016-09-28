{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, itstool, libxml2, python3Packages, at_spi2_core
, dbus, intltool, libwnck3 }:

stdenv.mkDerivation rec {
  name = "accerciser-3.14.0";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/3.14/${name}.tar.xz";
    sha256 = "0x05gpajpcs01g7m34g6fxz8122cf9kx3k0lchwl34jy8xfr39gm";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook itstool libxml2 python3Packages.python python3Packages.pyatspi
    python3Packages.pygobject3 python3Packages.ipython
    at_spi2_core dbus intltool libwnck3 gnome3.defaultIconTheme
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Accerciser;
    description = "Interactive Python accessibility explorer";
    maintainers = gnome3.maintainers;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
