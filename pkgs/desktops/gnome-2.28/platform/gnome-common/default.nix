{stdenv, fetchgit, pkgconfig, autoconf, automake, libtool}:

stdenv.mkDerivation {
  name = "gnome-common-2.28.0";
  src =  fetchgit {
    url = mirror:/gnome/sources/gnome-common/2.28/gnome-common-2.28.0.tar.bz2;
    rev = "53ca82d81d93b52bc057d649247eb18549a86d55";
    md5 = "a3e4c471c73af14d87fa753c2ee05f15";
  };
  buildInputs = [ pkgconfig automake autoconf libtool
    ];
  preConfigure = ''
    ./autogen.sh
  '';
}
