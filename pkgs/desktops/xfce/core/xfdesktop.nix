{ v, h, stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, xfconf, libglade, xfce4panel, thunar, exo, garcon, libnotify }:

stdenv.mkDerivation rec {
  name = "xfdesktop-${v}";
  src = fetchXfce.core name h;

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck xfconf
      libglade xfce4panel thunar exo garcon libnotify
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.xfce.org/projects/xfdesktop;
    description = "Xfce desktop manager";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
