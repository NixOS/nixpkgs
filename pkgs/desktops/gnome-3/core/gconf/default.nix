{ stdenv, fetchurl, pkgconfig, dbus-glib, gnome3 ? null, glib, libxml2
, intltool, polkit, orbit, python, withGtk ? false }:

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

  buildInputs = [ libxml2 polkit orbit python ] ++ stdenv.lib.optional withGtk gnome3.gtk;
  propagatedBuildInputs = [ glib dbus-glib  ];
  nativeBuildInputs = [ pkgconfig intltool ];

  # ToDo: ldap reported as not found but afterwards reported as supported

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    homepage = https://projects.gnome.org/gconf/;
    description = "A system for storing application preferences";
    platforms = platforms.linux;
  };
}
