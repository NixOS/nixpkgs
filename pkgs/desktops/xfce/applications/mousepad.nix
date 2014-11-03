{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, libxfcegui4
, gtk, gtksourceview, dbus, dbus_glib }:

stdenv.mkDerivation rec {
  p_name  = "mousepad";
  ver_maj = "0.3";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0v84zwhjv2xynvisn5vmp7dbxfj4l4258m82ks7hn3adk437bwhh";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool libxfce4util libxfcegui4
      gtk gtksourceview dbus dbus_glib
    ];

  # Propagate gtksourceview into $XDG_DATA_DIRS to provide syntax
  # highlighting (in fact Mousepad segfaults without it).
  propagatedUserEnvPkgs = [ gtksourceview ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "A simple text editor for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
