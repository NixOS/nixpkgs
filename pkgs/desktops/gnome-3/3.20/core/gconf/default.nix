{ stdenv, fetchurl, pkgconfig, dbus_glib, gnome3 ? null, glib, libxml2
, intltool, polkit, orbit, withGtk ? false }:

assert withGtk -> (gnome3 != null);

stdenv.mkDerivation rec {

  versionMajor = "3.2";
  versionMinor = "6";
  moduleName   = "GConf";

  origName = "${moduleName}-${versionMajor}.${versionMinor}";

  name = "gconf-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${origName}.tar.xz";
    sha256 = "0k3q9nh53yhc9qxf1zaicz4sk8p3kzq4ndjdsgpaa2db0ccbj4hr";
  };

  buildInputs = [ libxml2 polkit orbit ] ++ stdenv.lib.optional withGtk gnome3.gtk;
  propagatedBuildInputs = [ glib dbus_glib  ];
  nativeBuildInputs = [ pkgconfig intltool ];

  # ToDo: ldap reported as not found but afterwards reported as supported

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/gconf/;
    description = "A system for storing application preferences";
    platforms = platforms.linux;
  };
}
