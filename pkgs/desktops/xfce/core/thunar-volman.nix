{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, xfconf, udev, libnotify }:

stdenv.mkDerivation rec {
  p_name  = "thunar-volman";
  ver_maj = "0.8";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1sxw09fwyn5sr6ipxk7r8gqjyf41c2v7vkgl0l6mhy5mcb48f27z";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool exo gtk udev libxfce4ui libxfce4util
      xfconf libnotify
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  enableParallelBuilding = true;

  meta = {
    homepage = http://goodies.xfce.org/projects/thunar-plugins/thunar-volman;
    description = "Thunar extension for automatic management of removable drives and media";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
