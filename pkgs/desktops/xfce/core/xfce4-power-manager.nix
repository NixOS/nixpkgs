{ stdenv, lib, fetchurl, pkgconfig, intltool, glib, gtk, dbus-glib, upower, xfconf
, libxfce4ui, libxfce4util, libnotify, xfce4panel, hicolor-icon-theme
, withGtk3 ? false, gtk3, libxfce4ui_gtk3, xfce4panel_gtk3 }:
let
  p_name  = "xfce4-power-manager";
  ver_maj = if withGtk3 then "1.6" else "1.4";
  ver_min = if withGtk3 then "0"   else "4";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 =
      if withGtk3
      then "0avzhllpimcn7a6z9aa4jn0zg5ahxr9ks5ldchizycdb0rz1bqxx"
      else "01rvqy1cif4s8lkidb7hhmsz7d9f2fwcwvc51xycaj3qgsmch3n5";
  };

  buildInputs =
    [ pkgconfig intltool glib dbus-glib upower xfconf libxfce4util
      libnotify hicolor-icon-theme
    ] ++
    (if withGtk3
    then [ gtk3 libxfce4ui_gtk3 xfce4panel_gtk3 ]
    else [ gtk  libxfce4ui      xfce4panel      ]);

  postPatch = lib.optionalString withGtk3 ''
    substituteInPlace configure --replace gio-2.0 gio-unix-2.0
  '';

  postConfigure = lib.optionalString withGtk3 ''
    substituteInPlace src/Makefile      --replace "xfce4_power_manager_CFLAGS = "          "xfce4_power_manager_CFLAGS = \$(GIO_CFLAGS) "
    substituteInPlace settings/Makefile --replace "xfce4_power_manager_settings_CFLAGS = " "xfce4_power_manager_settings_CFLAGS = \$(GIO_CFLAGS) "
  '';

  meta = with stdenv.lib; {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-power-manager;
    description = "A power manager for the Xfce Desktop Environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}

