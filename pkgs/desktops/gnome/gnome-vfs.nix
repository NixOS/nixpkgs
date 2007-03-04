{ input, stdenv, fetchurl, gnome, pkgconfig, perl, libxml2
, popt, perlXMLParser, gettext, bzip2, dbus_glib
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl gnome.glib libxml2 gnome.GConf gnome.libbonobo
    gnome.gnomemimedata popt perlXMLParser gettext bzip2
    dbus_glib
  ];
  patches = [./no-kerberos.patch];
  configureFlags = "--disable-hal";
}
