{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel
, libxfce4ui, libxfcegui4, xfconf, gtk, hicolor-icon-theme }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-timer-plugin";
  ver_maj = "1.6";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0z46gyw3ihcd1jf0m5z1dsc790xv1cpi8mk1dagj3i4v14gx5mrr";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel libxfcegui4 xfconf
    gtk hicolor-icon-theme ];

  nativeBuildInputs = [ pkgconfig ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "A simple XFCE panel plugin that lets the user run an alarm at a specified time or at the end of a specified countdown period";
    longDescription = "The plugin is quite simple – it displays a progressbar showing the percentage of the time elapsed. Left-clicking on the plugin area opens a menu of available alarms. After selecting one, the user can start or stop the timer by selecting “start/stop timer” entry in the same menu. New alarms are added through the preferences window. Each alarm is either a countdown or is run at a specified time. By default a simple dialog pops up at the end of the countdown. The user can choose an external command to be run as the alarm and may also choose to have this repeated a specified number of times with a given interval between repetitions.";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
