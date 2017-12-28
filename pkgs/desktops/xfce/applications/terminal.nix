{ stdenv, fetchurl, pkgconfig, intltool, ncurses, dbus_glib
, exo, libxfce4util, libxfce4ui_gtk3, gtk3, gnome3
}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-terminal";
  ver_maj = "0.8";
  ver_min = "6";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "bc2a560409a0f0b666d1c557e991748b986ec27572a45ae88b0ee5a480d881d7";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool exo gnome3.vte libxfce4util ncurses dbus_glib libxfce4ui_gtk3 gtk3 ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
