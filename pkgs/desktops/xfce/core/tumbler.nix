{ stdenv, fetchurl, pkgconfig, intltool, dbus_glib, gdk_pixbuf }:

stdenv.mkDerivation rec {
  p_name  = "tumbler";
  ver_maj = "0.1";
  ver_min = "27";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0s9qj99b81asmlqa823nzykq8g6p9azcp2niak67y9bp52wv6q2c";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool dbus_glib gdk_pixbuf ];

  meta = {
    homepage = http://git.xfce.org/xfce/tumbler/;
    description = "A D-Bus thumbnailer service";
    license = "GPLv2";
  };
}
