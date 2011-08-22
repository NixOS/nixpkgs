{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, garcon
, libxfce4ui, xfconf, libwnck, exo }:

stdenv.mkDerivation rec {
  name = "xfce4-panel-4.8.5";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce4-panel/4.8/${name}.tar.bz2";
    sha1 = "67b9d5bc422663f60f5a05e7cfd7ca67b4542813";
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
  };
}
