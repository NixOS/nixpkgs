{ stdenv, fetchurl, pkgconfig, intltool, ncurses, gnome3, gtk3, dbus_glib
, exo, libxfce4util, libxfce4ui_gtk3
}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-terminal";
  ver_maj = "0.8";
  ver_min = "5.1";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0r70kdi4cx3q5cf6kqiy6k4ik3wkrma2qq44g6ankxmbg27mcd4a";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool exo gtk3 gnome3.vte_291 libxfce4util ncurses dbus_glib libxfce4ui_gtk3 ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
