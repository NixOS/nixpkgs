{ stdenv, fetchurl, pkgconfig, intltool
, gtk, dbus-glib, libstartup_notification, libnotify, libexif, pcre, udev
, exo, libxfce4util, xfconf, xfce4panel, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  p_name  = "thunar";
  ver_maj = "1.6";
  ver_min = "10";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/Thunar-${ver_maj}.${ver_min}.tar.bz2";
    sha256 = "7e9d24067268900e5e44d3325e60a1a2b2f8f556ec238ec12574fbea15fdee8a";
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
