{ stdenv, fetchurl, pkgconfig, gtk, intltool, libxfce4util
, libxfce4ui, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  name = "xfwm4-4.8.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfwm4/4.8/${name}.tar.bz2";
    sha1 = "4075a689f572ae157ed80ab3ce5be85f09dac766";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/;
    description = "Window manager for Xfce";
    license = "GPLv2+";
  };
}
