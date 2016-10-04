{ stdenv, fetchurl, pkgconfig, glib, popt, zlib, libcanberra
, intltool, libbonobo, GConf, gnome_vfs, ORBit2, libtool, libogg
}:

stdenv.mkDerivation rec {
  name = "libgnome-${minVer}.1";
  minVer = "2.32";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome/${minVer}/${name}.tar.bz2";
    sha256 = "197pnq8y0knqjhm2fg4j6hbqqm3qfzfnd0irhwxpk1b4hqb3kimj";
  };

  outputs = [ "out" "dev" ];

  patches = [ ./new-glib.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt zlib intltool GConf gnome_vfs libcanberra libtool ];
  propagatedBuildInputs = [ glib libbonobo libogg ];
}
