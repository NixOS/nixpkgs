{ stdenv, fetchurl, pkgconfig, libxml2, bzip2, openssl, samba, dbus_glib, glib, fam, hal, cdparanoia
, intltool, GConf, gnome_mime_data}:

stdenv.mkDerivation {
  name = "gnome-vfs-2.24.1";
  src = fetchurl {
    url = nirror://gnome/sources/gnome-vfs/2.24/gnome-vfs-2.24.1.tar.bz2;
    sha256 = "1dmyr8nj77717r8dhwkixpar2yp8ld3r683gp222n59v61718ndw";
  };
  buildInputs = [ pkgconfig libxml2 bzip2 openssl samba dbus_glib glib fam hal cdparanoia
                  intltool GConf gnome_mime_data ];
}
