{ v, h, stdenv, fetchXfce, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui, xfce4panel
, libwnck, dbus_glib, xfconf, libglade, xorg }:

#TODO: gnome stuff: gconf (assistive?), keyring

stdenv.mkDerivation rec {
  name = "xfce4-session-${v}";
  src = fetchXfce.core name h;

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util libxfce4ui libwnck dbus_glib
      xfconf xfce4panel libglade xorg.iceauth
    ];

  configureFlags = [ "--with-xsession-prefix=$$out" ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://www.xfce.org/projects/xfce4-session;
    description = "Session manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
