{ stdenv, fetchurl, pkgconfig, glib, popt, zlib, libcanberra-gtk2
, intltool, libbonobo, GConf, gnome_vfs, ORBit2, libtool, libogg
}:

stdenv.mkDerivation rec {
  name = "libgnome-${minVer}.1";
  minVer = "2.32";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome/${minVer}/${name}.tar.bz2";
    sha256 = "197pnq8y0knqjhm2fg4j6hbqqm3qfzfnd0irhwxpk1b4hqb3kimj";
  };

  patches = [ ./new-glib.patch ];
  /* There's a comment containing an invalid utf-8 sequence, breaking glib-mkenums. */
  postPatch = "sed '/returns the true filename/d' -i libgnome/gnome-config.h";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt zlib intltool GConf gnome_vfs libcanberra-gtk2 libtool ];
  propagatedBuildInputs = [ glib libbonobo libogg ];
}
