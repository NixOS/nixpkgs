{ stdenv, fetchurl, pkgconfig, libxml2, bzip2, openssl, dbus-glib
, glib, fam, cdparanoia, intltool, GConf, gnome_mime_data, avahi, acl }:

stdenv.mkDerivation rec {
  name = "gnome-vfs-${minVer}.4";
  minVer = "2.24";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-vfs/${minVer}/${name}.tar.bz2";
    sha256 = "1ajg8jb8k3snxc7rrgczlh8daxkjidmcv3zr9w809sq4p2sn9pk2";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ intltool pkgconfig ];
  buildInputs =
    [ libxml2 bzip2 openssl dbus-glib fam cdparanoia
      gnome_mime_data avahi acl
    ];

  propagatedBuildInputs = [ GConf glib ];

  postPatch = "find . -name Makefile.in | xargs sed 's/-DG_DISABLE_DEPRECATED//g' -i ";
}
