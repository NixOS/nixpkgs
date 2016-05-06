{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxml2, libsoup, upower,
libxfce4ui, libxfce4util, xfce4panel }:

stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";
  p_name  = "xfce4-weather-plugin";
  ver_maj = "0.8";
  ver_min = "7";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1c35iqqiphazkfdabbjdynk0qkc3r8vxhmk2jc6dkiv8d08727h7";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk libxml2 libsoup upower libxfce4ui libxfce4util
   xfce4panel ];

  enableParallelBuilding = true;

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Weather plugin for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
