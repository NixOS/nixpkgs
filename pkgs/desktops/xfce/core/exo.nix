{ stdenv, fetchurl, pkgconfig, intltool, URI, glib, gtk, libxfce4ui, libxfce4util }:

stdenv.mkDerivation rec {
  p_name  = "exo";
  ver_maj = "0.10";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1g9651ra395v2fmzb943l68b9pg0rfxc19x97a62crchxwa4nw4m";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool URI glib gtk libxfce4ui libxfce4util ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = "http://www.xfce.org/projects/${p_name}";
    description = "Application library for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
