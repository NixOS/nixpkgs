{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfcegui4 }:

stdenv.mkDerivation rec {
  name = "xfce-utils-4.6.2";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha1 = "6373886c3d70e576859741bde747a235567ffd8e";
  };

  configureFlags = "--with-xsession-prefix=$(out)/share/xsessions";

  buildInputs = [ pkgconfig intltool gtk libxfce4util libxfcegui4 ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Utilities and scripts for Xfce";
    license = "GPLv2+";
  };
}
