{ stdenv, fetchurl, pkgconfig, gtk, intltool, libxfce4util
, libxfce4ui, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  name = "xfwm4-4.8.3";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfwm4/4.8/${name}.tar.bz2";
    sha1 = "6d27deca383e0c2fba0cede0bbe0e9aee18e9257";
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
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
