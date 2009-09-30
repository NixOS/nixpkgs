{ stdenv, fetchurl, pkgconfig, dbus, samba, hal, libarchive, fuse, libgphoto2
, cdparanoia, libxml2, libtool, glib, intltool, GConf, gnome_keyring, libsoup}:

stdenv.mkDerivation {
  name = "gvfs-1.4.0";
  src = fetchurl {
    url = mirror:/gnome/sources/gvfs/1.4/gvfs-1.4.0.tar.bz2;
    sha256 = "1fzqq21888c1w357kcy8m12393wd6jjlk4pg118npn11m4gbb13s"
  };
  builder = ./builder.sh;
  buildInputs = [ pkgconfig dbus.libs samba hal libarchive fuse libgphoto2 cdparanoia libxml2 libtool
                  glib intltool GConf gnome_keyring libsoup ];
}
