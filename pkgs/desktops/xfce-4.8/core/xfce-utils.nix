{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui }:

stdenv.mkDerivation rec {
  name = "xfce-utils-4.8.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce-utils/4.8/${name}.tar.bz2";
    sha1 = "c9358f47f57b961fc51008cf6752d2761b4c4f25";
  };

  configureFlags = "--with-xsession-prefix=$(out)/share/xsessions --with-vendor-info=NixOS.org";

  buildInputs = [ pkgconfig intltool gtk libxfce4util libxfce4ui ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Utilities and scripts for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
