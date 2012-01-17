{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, xfconf, xorg, libnotify, libxklavier }:

stdenv.mkDerivation rec {
  name = "xfce4-settings-4.8.3";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce4-settings/4.8/${name}.tar.bz2";
    sha1 = "98431633ba3ec2a4a10182bc7266904d9256949b";
  };

  buildInputs =
    [ pkgconfig intltool exo gtk libxfce4util libxfce4ui
      xfconf libnotify xorg.libXcursor libxklavier
    ];

  configureFlags = "--enable-pluggable-dialogs --enable-sound-settings";

  meta = {
    homepage = http://www.xfce.org/;
    description = "Settings manager for Xfce";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
