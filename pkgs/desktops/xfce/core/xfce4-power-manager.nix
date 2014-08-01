{ stdenv, fetchurl, pkgconfig, intltool, gtk, dbus_glib, upower, xfconf
, libxfce4ui, libxfce4util, libnotify, xfce4panel }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-power-manager";
  ver_maj = "1.3";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1q0mnj9hjqw4zpk7wqnfayy6zzbjbhzd1mcplfjik2h753gaxgh5";
  };

  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs =
    [ pkgconfig intltool gtk dbus_glib upower xfconf libxfce4ui libxfce4util
      libnotify xfce4panel
    ];
  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-power-manager;
    description = "A power manager for the Xfce Desktop Environment";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
