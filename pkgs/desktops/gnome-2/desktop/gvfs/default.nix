{ stdenv, fetchurl, pkgconfig, dbus_libs, samba, libarchive, fuse, libgphoto2
, libcdio, libxml2, libtool, glib, intltool, GConf, libgnome_keyring, libsoup
, udev, avahi, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "gvfs-1.14.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gvfs/1.14/${name}.tar.xz";
    sha256 = "1g4ghyf45jg2ajdkv2d972hbckyjh3d9jdrppai85pl9pk2dmfy3";
  };

  buildInputs =
    [ glib dbus_libs udev samba libarchive fuse libgphoto2 libcdio libxml2 GConf
      libgnome_keyring libsoup avahi libtool libxslt docbook_xsl
    ];

  nativeBuildInputs = [ pkgconfig intltool ];

  enableParallelBuilding = true;
}
