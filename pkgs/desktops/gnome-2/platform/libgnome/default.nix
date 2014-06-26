{ stdenv, fetchurlGnome, pkgconfig, glib, popt, zlib, libcanberra
, intltool, libbonobo, GConf, gnome_vfs, ORBit2, libtool, libogg
}:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "libgnome";
    major = "2"; minor = "32"; patchlevel = "1";
    sha256 = "197pnq8y0knqjhm2fg4j6hbqqm3qfzfnd0irhwxpk1b4hqb3kimj";
  };

  patches = [ ./new-glib.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt zlib intltool GConf gnome_vfs libcanberra libtool ];
  propagatedBuildInputs = [ glib libbonobo libogg ];
}
