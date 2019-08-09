{ stdenv, fetchurl, pkgconfig, intltool, exo, gtk, libxfce4util, libxfce4ui
, xfconf, udev, libgudev, libnotify, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  p_name  = "thunar-volman";
  ver_maj = "0.8";
  ver_min = "1";
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1gf259n1v3y23n1zlkhyr6r0i8j59rnl1cmxvxj6la9cwdfbn22s";
  };


  buildInputs =
    [ pkgconfig intltool exo gtk udev libgudev libxfce4ui libxfce4util
      xfconf libnotify hicolor-icon-theme
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://goodies.xfce.org/projects/thunar-plugins/thunar-volman;
    description = "Thunar extension for automatic management of removable drives and media";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
