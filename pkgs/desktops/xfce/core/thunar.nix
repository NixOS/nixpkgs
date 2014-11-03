{ stdenv, fetchurl, pkgconfig, intltool
, gtk, dbus_glib, libstartup_notification, libnotify, libexif, pcre, udev
, exo, libxfce4util,  xfconf, xfce4panel
}:

stdenv.mkDerivation rec {
  p_name  = "thunar";
  ver_maj = "1.6";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/Thunar-${ver_maj}.${ver_min}.tar.bz2";
    sha256 = "17api7nc3h93k2mzrfmw6ygc0fqmg78ja0qbkzd9rhhsi3v0c9ws";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [
    pkgconfig intltool
    gtk dbus_glib libstartup_notification libnotify libexif pcre udev
    exo libxfce4util xfconf xfce4panel
  ];
  # TODO: optionality?

  enableParallelBuilding = true;

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Xfce file manager";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
