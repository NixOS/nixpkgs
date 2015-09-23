{ stdenv, fetchurl, pkgconfig, intltool
, gtk, dbus_glib, libstartup_notification, libnotify, libexif, pcre, udev
, exo, libxfce4util
, xfconf, libxfce4ui
}:

stdenv.mkDerivation rec {
  host_p_name = "thunar";
  p_name = "thunarx-2-dev";
  ver_maj = "1.6";
  ver_min = "6";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${host_p_name}/${ver_maj}/Thunar-${ver_maj}.${ver_min}.tar.bz2";
    sha256 = "1cl9v3rdzipyyxml3pyrzspxfmmssz5h5snpj18irq4an42539dr";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  preBuild = ''
    cd thunarx
  '';

  buildInputs = [
    pkgconfig intltool
    gtk dbus_glib libstartup_notification libnotify libexif pcre udev
    exo libxfce4util 
    xfconf libxfce4ui
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Thunar Extension Framework";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
