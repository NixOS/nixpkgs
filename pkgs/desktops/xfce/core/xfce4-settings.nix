{ v, h, stdenv, fetchXfce, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, libglade, xfconf, xorg, libwnck, libnotify, libxklavier, garcon }:

#TODO: optional packages
stdenv.mkDerivation rec {
  name = "xfce4-settings-${v}";
  src = fetchXfce.core name h;

  buildInputs =
    [ pkgconfig intltool exo gtk libxfce4util libxfce4ui libglade
      xfconf xorg.libXi xorg.libXcursor libwnck libnotify libxklavier garcon
    #gtk libxfce4util libxfcegui4 libwnck dbus_glib
      #xfconf libglade xorg.iceauth
    ];
  configureFlags = "--enable-pluggable-dialogs --enable-sound-settings";

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-settings;
    description = "Settings manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
