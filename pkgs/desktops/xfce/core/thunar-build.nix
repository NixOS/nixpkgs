{ stdenv, fetchurl, pkgconfig, intltool
, gtk, dbus-glib, libstartup_notification, libnotify, libexif, pcre, udev
, exo, libxfce4util, xfconf, xfce4-panel, hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  p_name  = "thunar";
  ver_maj = "1.8";
  ver_min = "2";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/Thunar-${ver_maj}.${ver_min}.tar.bz2";
    sha256 = "1fh6nn3ndpgmh9iawv49ppay0kbvic9mz2k2wqr8aha3lk428sm4";
  };

  name = "${p_name}-build-${ver_maj}.${ver_min}";

  patches = [ ./thunarx_plugins_directory.patch ];

  postPatch = ''
    sed -i -e 's|thunar_dialogs_show_insecure_program (parent, _(".*"), file, exec)|1|' thunar/thunar-file.c
  '';

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [
    intltool
    gtk dbus-glib libstartup_notification libnotify libexif pcre udev
    exo libxfce4util xfconf xfce4-panel
    hicolor-icon-theme
  ];
  # TODO: optionality?

  enableParallelBuilding = true;

  meta = {
    homepage = http://thunar.xfce.org/;
    description = "Xfce file manager";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
