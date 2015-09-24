{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfce4ui
, libwnck, xfconf, libglade, xfce4panel, thunar, exo, garcon, libnotify }:

stdenv.mkDerivation rec {
  p_name  = "xfdesktop";
  ver_maj = "4.12";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "a8a8d93744d842ca6ac1f9bd2c8789ee178937bca7e170e5239cbdbef30520ac";
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
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
