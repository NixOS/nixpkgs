{ stdenv, fetchurl, pkgconfig, intltool, ncurses, gtk, vte, dbus_glib
, exo, libxfce4util, libxfce4ui
}:

stdenv.mkDerivation rec {
  p_name  = "xfce4-terminal";
  ver_maj = "0.6";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1j6lpkq952mrl5p24y88f89wn9g0namvywhma639xxsswlkn8d31";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool exo gtk vte libxfce4util ncurses dbus_glib libxfce4ui ];

  meta = {
    homepage = http://www.xfce.org/projects/terminal;
    description = "A modern terminal emulator primarily for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
