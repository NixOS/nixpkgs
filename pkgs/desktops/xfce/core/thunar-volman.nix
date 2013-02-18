{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, xfconf, udev, libnotify }:

stdenv.mkDerivation rec {
  name = "thunar-volman-0.6.0";

  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/thunar-volman/0.6/${name}.tar.bz2";
    sha1 = "dcda936948623b342b290a78c294f71c038e832e";
  };

  buildInputs =
    [ pkgconfig intltool exo gtk udev libxfce4ui libxfce4util
      xfconf libnotify
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  enableParallelBuilding = true;

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Thunar extension for automatic management of removable drives and media";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
