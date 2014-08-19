{ stdenv, fetchurlGnome, flex, bison, pkgconfig, glib, dbus_glib, libxml2, popt
, intltool, ORBit2, procps }:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurlGnome {
    project = "libbonobo";
    major = "2"; minor = "32"; patchlevel = "1";
    sha256 = "0swp4kk6x7hy1rvd1f9jba31lvfc6qvafkvbpg9h0r34fzrd8q4i";
  };

  preConfigure = # still using stuff deprecated in new glib versions
    "sed 's/-DG_DISABLE_DEPRECATED//g' -i configure activation-server/Makefile.in";

  nativeBuildInputs = [ flex bison pkgconfig intltool procps ];
  buildInputs = [ libxml2 ];
  propagatedBuildInputs = [ popt glib ORBit2 ];
}
