{ stdenv, fetchurl, pkgconfig, glib, dbus, intltool, udev, libgdu, fuse
, libxml2, libxslt, docbook_xsl, libgphoto2, libtool }:

stdenv.mkDerivation rec {
  name = "gvfs-1.14.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/1.14/${name}.tar.xz";
    sha256 = "1g4ghyf45jg2ajdkv2d972hbckyjh3d9jdrppai85pl9pk2dmfy3";
  };

  buildInputs =
    [ pkgconfig glib dbus.libs intltool udev libgdu fuse libxml2 libxslt
      docbook_xsl libgphoto2 libtool
    ];

  meta = {
    description = "Virtual Filesystem support library (for Xfce)";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
