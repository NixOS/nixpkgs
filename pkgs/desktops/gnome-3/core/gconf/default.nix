{ stdenv, fetchurl, pkgconfig, dbus_glib, gnome3, libxml2
, intltool, dbus_libs, polkit }:

stdenv.mkDerivation rec {

  versionMajor = "3.2";
  versionMinor = "5";
  moduleName   = "GConf";

  origName = "${moduleName}-${versionMajor}.${versionMinor}";
  
  name = "gconf-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${origName}.tar.xz";
    sha256 = "1ijqks0jxc4dyfxg4vnbqds4aj6miyahlsmlqlkf2bi1798akpjd";
  };

  buildInputs = [ dbus_libs dbus_glib libxml2 polkit gnome3.gtk ];
  propagatedBuildInputs = [ gnome3.glib ];
  buildNativeInputs = [ pkgconfig intltool ];
}
