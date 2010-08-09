{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfcegui4
, libwnck, xfconf, libglade }:

stdenv.mkDerivation rec {
  name = "xfdesktop-4.6.2";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha1 = "cefcd1c1386d34386d4e900cbf88b7c24ef3bafb";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfcegui4 libwnck xfconf
      libglade ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce desktop manager";
    license = "GPLv2+";
  };
}
