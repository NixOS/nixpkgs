{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, garcon
, libxfce4ui, xfconf, libwnck, exo }:

stdenv.mkDerivation rec {
  name = "xfce4-panel-4.8.6";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce4-panel/4.8/${name}.tar.bz2";
    sha1 = "332fc968332e6271e1bb65d6de8de2524b0440ec";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util garcon libxfce4ui xfconf
      exo libwnck
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce panel";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
