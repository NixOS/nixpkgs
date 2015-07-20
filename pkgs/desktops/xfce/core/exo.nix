{ stdenv, fetchurl, pkgconfig, intltool, URI, glib, gtk, libxfce4ui, libxfce4util }:

stdenv.mkDerivation rec {
  p_name  = "exo";
  ver_maj = "0.10";
  ver_min = "6";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1cc0e5a432e050a5e5aa64d126b988f4440da4f27474aaf42a4d8e13651d0752";
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
