{ stdenv, fetchurl_gnome, flex, bison, pkgconfig, glib, dbus_glib, libxml2, popt
, intltool, ORBit2, procps }:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurl_gnome {
    project = "libbonobo";
    major = "2"; minor = "32"; patchlevel = "1";
    sha256 = "0swp4kk6x7hy1rvd1f9jba31lvfc6qvafkvbpg9h0r34fzrd8q4i";
  };

  preConfigure = "export USER=`whoami`";
  nativeBuildInputs = [ flex bison pkgconfig intltool procps ];
  buildInputs = [ libxml2 ];
  propagatedBuildInputs = [ popt glib ORBit2 ];
}
