{ stdenv, fetchurl_gnome, pkgconfig, glib, popt, zlib, libcanberra
, intltool, libbonobo, GConf, gnome_vfs, ORBit2, libtool}:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurl_gnome {
    project = "libgnome";
    major = "2"; minor = "32"; patchlevel = "1";
    sha256 = "197pnq8y0knqjhm2fg4j6hbqqm3qfzfnd0irhwxpk1b4hqb3kimj";
  };
  
  buildNativeInputs = [ pkgconfig ];
  buildInputs = [ popt zlib intltool GConf gnome_vfs libcanberra libtool ];
  propagatedBuildInputs = [ glib libbonobo ];
}
