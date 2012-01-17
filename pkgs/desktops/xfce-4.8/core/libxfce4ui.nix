{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "libxfce4ui-4.8.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/libxfce4ui/4.8/${name}.tar.bz2";
    sha1 = "408645581e589135aa03d2e9b84f4eede68596b2";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util xfconf
      libstartup_notification
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic GUI library for Xfce";
    license = "LGPLv2+";
  };
}
