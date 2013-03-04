{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, xfconf, libglade, xfce4panel, thunar, exo, garcon, libnotify }:

stdenv.mkDerivation rec {
  p_name  = "xfdesktop";
  ver_maj = "4.10";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1bfl2xzmci7vqwwz2k2gp7ykysjnq9dcwpnzkwbpv5hv3qwgx0r8";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

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
