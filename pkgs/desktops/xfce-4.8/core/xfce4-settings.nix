{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, xfconf, xorg, libnotify, libxklavier }:

stdenv.mkDerivation rec {
  name = "xfce4-settings-4.8.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/xfce4-settings/4.8/${name}.tar.bz2";
    sha1 = "402afe308944a315c385d2b1ed567f997d016b61";
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
  };
}
