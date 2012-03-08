{stdenv, fetchurl, pkgconfig, libX11, gtk, intltool}:

stdenv.mkDerivation {
  name = "libwnck-2.30.7";

  src = fetchurl {
    url = mirror://gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz;
    sha256 = "15713yl0f8f3p99jzqqfmbicrdswd3vwpx7r3bkf1bgh6d9lvs4b";
  };

  buildInputs = [ pkgconfig libX11 gtk intltool ];
}
