{ stdenv, fetchurl, pkgconfig, dbus_libs, samba, libarchive, fuse, libgphoto2
, libcdio, libxml2, libtool, glib, intltool, GConf, libgnome_keyring, libsoup
, udev, avahi}:

stdenv.mkDerivation {
  name = "gvfs-1.10.1";

  src = fetchurl {
    url = mirror://gnome/sources/gvfs/1.10/gvfs-1.10.1.tar.xz;
    sha256 = "124jrkph3cqr2pijmzzr6qwzy2vaq3vvndskzkxd0v5dwp7glc6d";
  };

  buildInputs =
    [ glib dbus_libs udev samba libarchive fuse libgphoto2 libcdio libxml2 GConf
      libgnome_keyring libsoup avahi libtool
    ];

  buildNativeInputs = [ pkgconfig intltool ];
}
