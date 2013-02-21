{ stdenv, fetchurl, pkgconfig, dbus_glib, gtk, glib, libxml2
, intltool, polkit, orbit }:

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

  buildInputs = [ libxml2 polkit gtk orbit ];
  propagatedBuildInputs = [ glib dbus_glib  ];
  nativeBuildInputs = [ pkgconfig intltool ];

  # ToDo: ldap reported as not found but afterwards reported as supported

  meta = {
    homepage = http://projects.gnome.org/gconf/;
    description = "A system for storing application preferences";
  };
}
