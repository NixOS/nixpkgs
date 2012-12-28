{ stdenv, fetchurl, pkgconfig, dbus_libs, samba, libarchive, fuse, libgphoto2
, libcdio, libxml2, libtool, glib, intltool, GConf, libgnome_keyring, libsoup
, udev, avahi, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "gvfs-1.14.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/1.14/${name}.tar.xz";
    sha256 = "0af86cd7ee7b6daca144776bdf12f2f30d3e18fdd70b4da58e1a68cea4f6716a";
  };

  buildInputs =
    [ glib dbus_libs udev samba libarchive fuse libgphoto2 libcdio libxml2 GConf
      libgnome_keyring libsoup avahi libtool libxslt docbook_xsl
    ];

  nativeBuildInputs = [ pkgconfig intltool ];

  enableParallelBuilding = true;
}
