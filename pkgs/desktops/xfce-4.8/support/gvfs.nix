{ stdenv, fetchurl, pkgconfig, glib, dbus, intltool, udev }:

stdenv.mkDerivation rec {
  name = "gvfs-1.8.2";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/1.8/${name}.tar.bz2";
    sha256 = "0895ac8f6d416e1b15433b6b6b68eb119c6e8b04fdb66db665d684355ef89345";
  };

  buildInputs = [ pkgconfig glib dbus.libs intltool udev ];

  meta = {
    description = "Virtual Filesystem support library (for Xfce)";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
