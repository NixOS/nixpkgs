{ stdenv, fetchurl, pkgconfig, glib, dbus, intltool, udev, libgdu, fuse
, libxml2, libxslt, docbook_xsl, libgphoto2, libtool }:

stdenv.mkDerivation rec {
  name = "gvfs-1.14.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/1.14/${name}.tar.xz";
    sha256 = "0af86cd7ee7b6daca144776bdf12f2f30d3e18fdd70b4da58e1a68cea4f6716a";
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
