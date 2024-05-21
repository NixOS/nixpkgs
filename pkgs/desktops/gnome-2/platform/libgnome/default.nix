{ lib, stdenv, fetchurl, pkg-config, glib, popt, zlib, libcanberra-gtk2
, intltool, libbonobo, GConf, gnome_vfs, libtool, libogg
}:

stdenv.mkDerivation rec {
  pname = "libgnome";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome/${lib.versions.majorMinor version}/libgnome-${version}.tar.bz2";
    sha256 = "197pnq8y0knqjhm2fg4j6hbqqm3qfzfnd0irhwxpk1b4hqb3kimj";
  };

  patches = [ ./new-glib.patch ];
  /* There's a comment containing an invalid utf-8 sequence, breaking glib-mkenums. */
  postPatch = "sed '/returns the true filename/d' -i libgnome/gnome-config.h";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ popt zlib GConf gnome_vfs libcanberra-gtk2 libtool ];
  propagatedBuildInputs = [ glib libbonobo libogg ];
  meta.mainProgram = "gnome-open";
}
