{ stdenv, fetchurl_gnome, pkgconfig, libxml2, bzip2, openssl, samba, dbus_glib
, glib, fam, cdparanoia, intltool, GConf, gnome_mime_data, avahi, acl }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "gnome-vfs";
    major = "2"; minor = "24"; patchlevel = "4";
    sha256 = "1ajg8jb8k3snxc7rrgczlh8daxkjidmcv3zr9w809sq4p2sn9pk2";
  };

  buildInputs =
    [ pkgconfig libxml2 bzip2 openssl samba dbus_glib fam cdparanoia
      intltool gnome_mime_data avahi acl
    ];

  propagatedBuildInputs = [ GConf glib ];
}
