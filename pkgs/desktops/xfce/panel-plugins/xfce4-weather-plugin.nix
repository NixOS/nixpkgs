{ stdenv, fetchurl, pkgconfig, intltool, gtk2, libxml2, libsoup, upower,
libxfce4ui, libxfce4util, xfce4-panel, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";
  p_name  = "xfce4-weather-plugin";
  ver_maj = "0.8";
  ver_min = "10";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1f7ac2zr5s5w6krdpgsq252wxhhmcblia3j783132ilh8k246vgf";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk2 libxml2 libsoup upower libxfce4ui libxfce4util
   xfce4-panel hicolor-icon-theme ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Weather plugin for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
