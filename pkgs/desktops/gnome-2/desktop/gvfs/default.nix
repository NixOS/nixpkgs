{ stdenv, fetchurl, pkgconfig, dbus_libs, samba, libarchive, fuse, libgphoto2
, libcdio, libxml2, libtool, glib, intltool, GConf, libgnome_keyring, libsoup
, udev, avahi}:

stdenv.mkDerivation {
  name = "gvfs-1.8.2";

  src = fetchurl {
    url = mirror://gnome/sources/gvfs/1.8/gvfs-1.8.2.tar.bz2;
    sha256 = "0ickz1g3b16ncnv6vdpx0j5nx70ixdl6nsrv8cainvj1dn7sr588";
  };

  buildInputs =
    [ glib dbus_libs udev samba libarchive fuse libgphoto2 libcdio libxml2 GConf
      libgnome_keyring libsoup avahi libtool
    ];

  buildNativeInputs = [ pkgconfig intltool ];
}
