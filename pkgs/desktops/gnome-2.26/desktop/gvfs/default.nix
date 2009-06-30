{ stdenv, fetchurl, pkgconfig, dbus, samba, hal, libarchive, fuse, libgphoto2
, cdparanoia, libxml2, libtool, glib, intltool, GConf, gnome_keyring, libsoup}:

stdenv.mkDerivation {
  name = "gvfs-1.2.3";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/gvfs-1.2.3.tar.bz2;
    sha256 = "0yaq7qi9da963ppp7jlgac3zzwlhczpp1swdbaklnl343c64hp9r";
  };
  builder = ./builder.sh;
  buildInputs = [ pkgconfig dbus.libs samba hal libarchive fuse libgphoto2 cdparanoia libxml2 libtool
                  glib intltool GConf gnome_keyring libsoup ];
}
