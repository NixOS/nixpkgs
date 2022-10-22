{ lib, stdenv, fetchurl, flex, bison, pkg-config, glib, libxml2, popt
, intltool, ORBit2, procps }:

stdenv.mkDerivation rec {
  pname = "libbonobo";
  version = "2.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libbonobo/${lib.versions.majorMinor version}/libbonobo-${version}.tar.bz2";
    sha256 = "0swp4kk6x7hy1rvd1f9jba31lvfc6qvafkvbpg9h0r34fzrd8q4i";
  };

  outputs = [ "out" "dev" ];

  preConfigure = # still using stuff deprecated in new glib versions
    "sed 's/-DG_DISABLE_DEPRECATED//g' -i configure activation-server/Makefile.in";

  nativeBuildInputs = [ flex bison pkg-config intltool procps ];
  buildInputs = [ libxml2 ];
  propagatedBuildInputs = [ popt glib ORBit2 ];
}
