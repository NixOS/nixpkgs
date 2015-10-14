{ stdenv, fetchurl, pkgconfig, intltool, gtk, dbus_glib, upower, xfconf
, libxfce4ui, libxfce4util, libnotify, xfce4panel, hicolor_icon_theme }:
let
  p_name  = "xfce4-power-manager";
  ver_maj = "1.4";
  ver_min = "4";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "01rvqy1cif4s8lkidb7hhmsz7d9f2fwcwvc51xycaj3qgsmch3n5";
  };

  buildInputs =
    [ pkgconfig intltool gtk dbus_glib upower xfconf libxfce4ui libxfce4util
      libnotify xfce4panel hicolor_icon_theme
    ];

  meta = with stdenv.lib; {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-power-manager;
    description = "A power manager for the Xfce Desktop Environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}

