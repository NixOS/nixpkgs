{ stdenv, fetchurl, pkgconfig, intltool
, gtk, dbus_glib, libstartup_notification, libnotify, libexif, pcre, udev
, exo, libxfce4util,  xfconf, xfce4panel
}:

stdenv.mkDerivation rec {
  p_name  = "thunar";
  ver_maj = "1.6";
  ver_min = "6";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/Thunar-${ver_maj}.${ver_min}.tar.bz2";
    sha256 = "1cl9v3rdzipyyxml3pyrzspxfmmssz5h5snpj18irq4an42539dr";
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
