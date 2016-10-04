{ stdenv, fetchurl, pkgconfig, libxml2, bzip2, openssl, samba, dbus_glib
, glib, fam, cdparanoia, intltool, GConf, gnome_mime_data, avahi, acl }:

stdenv.mkDerivation rec {
  name = "gnome-vfs-${minVer}.4";
  minVer = "2.24";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-vfs/${minVer}/${name}.tar.bz2";
    sha256 = "1ajg8jb8k3snxc7rrgczlh8daxkjidmcv3zr9w809sq4p2sn9pk2";
  };

  outputs = [ "out" "dev" ];

  buildInputs =
    [ pkgconfig libxml2 bzip2 openssl samba dbus_glib fam cdparanoia
      intltool gnome_mime_data avahi acl
    ];

  propagatedBuildInputs = [ GConf glib ];

  postPatch = "find . -name Makefile.in | xargs sed 's/-DG_DISABLE_DEPRECATED//g' -i ";
}
