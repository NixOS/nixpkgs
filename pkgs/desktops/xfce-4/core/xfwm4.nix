{ stdenv, fetchurl, pkgconfig, gtk, intltool, libglade, libxfce4util
, libxfcegui4, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  name = "xfwm4-4.6.2";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha256 = "0a2q2pr5mzp6hsrd0llr90i9wii2qj2054shkpvkain20gp1ja11";
  };

  buildInputs =
    [ pkgconfig intltool gtk libglade libxfce4util libxfcegui4 xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Window manager for Xfce";
    license = "GPLv2+";
  };
}
