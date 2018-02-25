{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, itstool, libxml2, python3Packages, at-spi2-core
, dbus, intltool, libwnck3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) src name;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook itstool libxml2 python3Packages.python python3Packages.pyatspi
    python3Packages.pygobject3 python3Packages.ipython
    at-spi2-core dbus intltool libwnck3 gnome3.defaultIconTheme
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
