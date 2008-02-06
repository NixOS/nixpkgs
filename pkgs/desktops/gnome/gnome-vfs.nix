args: with args;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl gnome.glib libxml2 gnome.libbonobo
    gnome.gnomemimedata popt perlXMLParser gettext bzip2
    dbus_glib hal openssl samba fam
  ];

  propagatedBuildInputs = [gnome.GConf];
  patches = [./no-kerberos.patch];
}
