{ stdenv, fetchurlGnome, pkgconfig, libxml2, bzip2, openssl, samba, dbus_glib
, glib, fam, cdparanoia, intltool, GConf, gnome_mime_data, avahi, acl }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "gnome-vfs";
    major = "2"; minor = "24"; patchlevel = "4";
    sha256 = "1ajg8jb8k3snxc7rrgczlh8daxkjidmcv3zr9w809sq4p2sn9pk2";
  };

  buildInputs =
    [ pkgconfig libxml2 bzip2 openssl samba dbus_glib fam cdparanoia
      intltool gnome_mime_data avahi acl
    ];

  propagatedBuildInputs = [ GConf glib ];

  postPatch = "find . -name Makefile.in | xargs sed 's/-DG_DISABLE_DEPRECATED//g' -i ";
}
