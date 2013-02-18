{ v, h, stdenv, fetchXfce, pkgconfig, gtk, intltool, libglade, libxfce4util
, libxfce4ui, xfconf, libwnck, libstartup_notification, xorg }:

stdenv.mkDerivation rec {
  name = "xfwm4-${v}";
  src = fetchXfce.core name h;

  #TODO: kde systray, docs
  buildInputs =
    [ pkgconfig intltool gtk libglade libxfce4util libxfce4ui xfconf
      libwnck libstartup_notification
      xorg.libXcomposite xorg.libXfixes xorg.libXdamage
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/xfwm4;
    description = "Window manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
