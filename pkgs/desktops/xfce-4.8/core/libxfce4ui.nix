{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, xfconf
, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "libxfce4ui-4.8.0";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/libxfce4ui/4.8/${name}.tar.bz2";
    sha1 = "107f9d8e3e583f3cf5330074e89ea72eb2a82888";
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
